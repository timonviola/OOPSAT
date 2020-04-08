function fm_spf(obj)
% FM_SPF solve standard power flow by means of the NR method
%       and fast decoupled power flow (XB and BX variations)
%       with either a single or distributed slack bus model.
%
% FM_SPF
%
%see the properties of the obj.Settings structure for options.
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    09-Jul-2003
%Version:   1.0.1
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

obj.fm_disp
obj.fm_disp('Newton-Raphson Method for Power Flow Computation')
if obj.Settings.show
  obj.fm_disp(['Data file "',obj.Path.data,obj.File.data,'"'])
end
nodyn = 0;

% these computations are needed only the first time the power flow is run
if ~obj.Settings.init
  % bus type initialization
  obj.fm_ncomp
  if ~obj.Settings.ok, return, end
  % report components parameters to system bases
  if obj.Settings.conv
% CALL FM BASE
      fm_base(obj)
  end
  % create the admittance matrix
  obj.Line = build_y(obj.Line,obj);
  % create the FM_CALL FUNCTION
  if obj.Settings.show
      obj.fm_disp('Writing file "fm_call" ...',1)
  end
  %% CALL FM_WCALL FM_DYNLF
  obj.fm_wcall;
  obj.fm_dynlf; % indicization of components used in power flow computations
end

% memory allocation for equations and Jacobians
obj.DAE.g = ones(obj.DAE.m,1);
obj.DAE.Gy = sparse(obj.DAE.m,obj.DAE.m);
if (obj.DAE.n~=0)
  obj.DAE.f = ones(obj.DAE.n,1); % differential equations
  obj.DAE.x = ones(obj.DAE.n,1); % state variables
  fm_xfirst;
  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n); % df/dx
  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m); % df/dy
  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n); % dg/dx
else  % no dynamic elements
  nodyn = 1;
  obj.DAE.n = 1;
  obj.DAE.f = 0;
  obj.DAE.x = 0;
  obj.DAE.Fx = 1;
  obj.DAE.Fy = sparse(1,obj.DAE.m);
  obj.DAE.Gx = sparse(obj.DAE.m,1);
end

% check PF solver method
PFmethod = obj.Settings.pfsolver;

ncload = getnum(obj.Mn) + getnum(obj.Pl) + getnum(obj.Lines) + (~nodyn);
if (ncload || obj.Settings.distrsw) && (PFmethod == 2 || PFmethod == 3)
  if ncload
    obj.fm_disp('Fast Decoupled PF cannot be used with dynamic components')
  end
  if obj.Settings.distrsw
    obj.fm_disp('Fast Decoupled PF cannot be used with distributed slack bus model')
  end
  PFmethod = 1; % force using standard NR method
end

switch PFmethod
 case 1, obj.fm_disp('PF solver: Newton-Raphson method')
 case 2, obj.fm_disp('PF solver: XB fast decoupled method')
 case 3, obj.fm_disp('PF solver: BX fast decoupled method')
 case 4, obj.fm_disp('PF solver: Runge-Kutta method')
 case 5, obj.fm_disp('PF solver: Iwamoto method')
 case 6, obj.fm_disp('PF solver: Robust power flow method')
 case 7, obj.fm_disp('PF solver: DC power flow')
end

obj.DAE.lambda = 1;
Jrow = 0;
if obj.Settings.distrsw
  obj.DAE.Fk = sparse(obj.DAE.n,1);
  obj.DAE.Gk = sparse(obj.DAE.m,1);
  Jrow = sparse(1,obj.DAE.n+obj.SW.refbus,1,1,obj.DAE.n+obj.DAE.m+1);
  obj.DAE.kg = 0;
  if ~swgamma(obj.SW,'sum')
    obj.fm_disp('Slack buses have zero power loss participation factor.')
    obj.fm_disp('Single slack bus model will be used')
    Setting.distrsw = 0;
  end
  if totp(obj.SW) == 0
    obj.SW = setpg(totp(obj.PQ)-totp(PV),1);
    obj.fm_disp('Slack buses have zero generated power.')
    obj.fm_disp('P_slack = sum(P_load)-sum(P_gen) will be used.')
    obj.fm_disp('Only obj.PQ loads and PV generators are used.')
    obj.fm_disp('If there are convergence problems, use the single slack bus model.')
  end
  Gkcall(obj.SW);
  Gkcall(PV);
end

switch obj.Settings.distrsw
 case 1
  obj.fm_disp('Distributed slack bus model')
 case 0
  obj.fm_disp('Single slack bus model')
end

iter_max = obj.Settings.lfmit;
convergence = 1;
if iter_max < 2, iter_max = 2; end
iteration = 0;
tol = obj.Settings.lftol;
obj.Settings.error = tol+1;
obj.Settings.iter = 0;
err_max_old = 1e6;
err_vec = [];
alfatry = 1;
alfa = 1; %0.85;
safety = 0.9;
pgrow = -0.2;
pshrnk = -0.25;
robust = 1;
try
  errcon = (5/safety)^(1/pgrow);
catch
  errcon = 1.89e-4;
end

% Graphical settings
%% fm_stattus call
obj.fm_status('pf','init',iter_max,{'r'},{'-'},{obj.Theme.color11})
islands(obj.Line,obj)

%  Newton-Raphson routine
t0 = clock;

while (obj.Settings.error > tol) && (iteration <= iter_max) && (alfa > 1e-5)

  if ishandle(obj.Fig.main)
    if ~get(obj.Fig.main,'UserData'), break, end
  end

  switch PFmethod

   case 1 % Standard Newton-Raphson method

    inc = calcInc(nodyn,Jrow,obj);
    obj.DAE.x = obj.DAE.x + inc(1:obj.DAE.n);
    obj.DAE.y = obj.DAE.y + inc(1+obj.DAE.n:obj.DAE.m+obj.DAE.n);
    if obj.Settings.distrsw, obj.DAE.kg = obj.DAE.kg + inc(end); end

   case {2,3} % Fast Decoupled Power Flow

    if ~iteration % initialize variables
      obj.Line = build_b(obj.Line);
      no_sw = obj.Bus.a;
      no_sw(getbus(obj.SW)) = [];
      no_swv = no_sw + obj.Bus.n;
      no_g = obj.Bus.a;
      no_g([getbus(obj.SW); getbus(PV)]) = [];
      Bp = obj.Line.Bp(no_sw,no_sw);
      Bpp = obj.Line.Bpp(no_g,no_g);
      [Lp, Up, Pp] = lu(Bp);
      [Lpp, Upp, Ppp] = lu(Bpp);
      no_g = no_g + obj.Bus.n;
      obj.fm_call('fdpf')
    end

    % P-theta
    da = -(Up\(Lp\(Pp*(obj.DAE.g(no_sw)./obj.DAE.y(no_swv)))));
    obj.DAE.y(no_sw) = obj.DAE.y(no_sw) + da;
    obj.fm_call('fdpf')
    normP = norm(obj.DAE.g,inf);

    % Q-V
    dV = -(Upp\(Lpp\(Ppp*(obj.DAE.g(no_g)./obj.DAE.y(no_g)))));
    obj.DAE.y(no_g) = obj.DAE.y(no_g)+dV;
    obj.fm_call('fdpf')
    normQ = norm(obj.DAE.g,inf);

    inc = [normP; normQ];

    % recompute Bpp if some PV bus has been switched to obj.PQ bus
    if obj.Settings.pv2pq && strmatch('Switch',obj.History.text{end})
      fm_disp('Recomputing Bpp matrix for Fast Decoupled PF')
      no_g = obj.Bus.a;
      no_g([getbus(obj.SW); getbus(PV)]) = [];
      Bpp = obj.Line.Bpp(no_g,no_g);
      [Lpp, Upp, Ppp] = lu(Bpp);
      no_g = no_g + obj.Bus.n;
    end

   case 4 % Runge-Kutta method

    xold = obj.DAE.x;
    yold = obj.DAE.y;
    kold = obj.DAE.kg;

    k1 = alfa*calcInc(nodyn,Jrow);

    Jac = -[obj.DAE.Fx, obj.DAE.Fy; obj.DAE.Gx, obj.DAE.Gy];

    obj.DAE.x = xold + 0.5*k1(1:obj.DAE.n);
    obj.DAE.y = yold + 0.5*k1(1+obj.DAE.n:obj.DAE.m+obj.DAE.n);
    if obj.Settings.distrsw, obj.DAE.kg = kold + 0.5*k1(end); end

    k2 = alfa*calcInc(nodyn,Jrow);

    obj.DAE.x = xold + 0.5*k2(1:obj.DAE.n);
    obj.DAE.y = yold + 0.5*k2(1+obj.DAE.n:obj.DAE.m+obj.DAE.n);
    if obj.Settings.distrsw, obj.DAE.kg = kold + 0.5*k2(end); end

    k3 = alfa*calcInc(nodyn,Jrow);

    obj.DAE.x = xold + k3(1:obj.DAE.n);
    obj.DAE.y = yold + k3(1+obj.DAE.n:obj.DAE.m+obj.DAE.n);
    if obj.Settings.distrsw, obj.DAE.kg = kold + k3(end); end

    k4 = alfa*calcInc(nodyn,Jrow);

    % compute RK4 increment of variables
    inc = (k1+2*(k2+k3)+k4)/6;

    % to estimate RK error, use the RK2:Dy and RK4:Dy.
    yerr = max(abs(abs(k2)-abs(inc)));
    if yerr > 0.01
      alfa = max(0.985*alfa,0.75);
    else
      alfa = min(1.015*alfa,0.75);
    end

    obj.DAE.x = xold + inc(1:obj.DAE.n);
    obj.DAE.y = yold + inc(1+obj.DAE.n:obj.DAE.m+obj.DAE.n);
    if obj.Settings.distrsw, obj.DAE.kg = kold + inc(end); end

   case 5 % Iwamoto method

    xold = obj.DAE.x;
    yold = obj.DAE.y;
    kold = obj.DAE.kg;

    inc = calcInc(nodyn,Jrow);

    vec_a = -[obj.DAE.Fx, obj.DAE.Fy; obj.DAE.Gx, obj.DAE.Gy]*inc;
    vec_b = -vec_a;
    obj.DAE.x = inc(1:obj.DAE.n);
    obj.DAE.y = inc(1+obj.DAE.n:obj.DAE.m+obj.DAE.n);

    if obj.Settings.distrsw
      obj.DAE.kg = inc(end);
      obj.fm_call('kgpf');
      if nodyn, obj.DAE.Fx = 1; end
      vec_c = -[obj.DAE.f; obj.DAE.g; obj.DAE.y(obj.SW.refbus)];
    else
      refreshJac(obj);
      obj.fm_call('l');
      refreshGen(nodyn);
      vec_c = -[obj.DAE.f; obj.DAE.g];
    end

    g0 = (vec_a')*vec_b;
    g1 = sum(vec_b.*vec_b + 2*vec_a.*vec_c);
    g2 = 3*(vec_b')*vec_c;
    g3 = 2*(vec_c')*vec_c;

    % mu = fsolve(@(x) g0 + x*(g1 + x*(g2 + x*g3)), 1.0);

    % Cardan's formula
    pp = -g2/3/g3;
    qq = pp^3 + (g2*g1-3*g3*g0)/6/g3/g3;
    rr = g1/3/g3;

    mu = (qq+sqrt(qq*qq+(rr-pp*pp)^3))^(1/3) + ...
         (qq-sqrt(qq*qq+(rr-pp*pp)^3))^(1/3) + pp;

    mu = min(abs(mu),0.75);

    obj.DAE.x = xold + mu*inc(1:obj.DAE.n);
    obj.DAE.y = yold + mu*inc(1+obj.DAE.n:obj.DAE.n+obj.DAE.m);
    if obj.Settings.distrsw, obj.DAE.kg = kold + mu*inc(end); end

   case 6 % simple robust power flow method

    inc = robust*calcInc(nodyn,Jrow);
    obj.Settings.error = max(abs(inc));

    if obj.Settings.error > 1.5*err_max_old && iteration
      robust = 0.25*robust;
      if robust < tol
        fm_disp('The otpimal multiplier is too small.')
        iteration = iter_max+1;
        break
      end
    else
      obj.DAE.x = obj.DAE.x + inc(1:obj.DAE.n);
      obj.DAE.y = obj.DAE.y + inc(1+obj.DAE.n:obj.DAE.m+obj.DAE.n);
      if obj.Settings.distrsw, obj.DAE.kg = obj.DAE.kg + inc(end); end
      err_max_old = obj.Settings.error;
      robust = 1;
    end

  end

  iteration = iteration + 1;
  obj.Settings.error = max(abs(inc));
  obj.Settings.iter = iteration;
  err_vec(iteration) = obj.Settings.error;

  if obj.Settings.error < 1e-2 && PFmethod > 3 && obj.Settings.switch2nr
    fm_disp('Switch to standard Newton-Raphson method.')
    PFmethod = 1;
  end

  obj.fm_status('pf','update',[iteration, obj.Settings.error],iteration)

  if obj.Settings.show
    if obj.Settings.error == Inf, obj.Settings.error = 1e3; end
    obj.fm_disp(['Iteration = ', num2str(iteration), ...
             '     Maximum Convergency Error = ', ...
             num2str(obj.Settings.error)],1)
  end

  % stop if the error increases too much
  if iteration > 4
    if err_vec(iteration) > 1000*err_vec(1)
      obj.fm_disp('The error is increasing too much.')
      obj.fm_disp('Convergence is likely not reachable.')
      convergence = 0;
      break
    end
  end

end

obj.Settings.lftime = etime(clock,t0);
if iteration > iter_max
  obj.fm_disp(['Reached maximum number of iteration of NR routine without ' ...
           'convergence'],2)
  convergence = 0;
end

% Total power injections and consumptions at network buses

% obj.Pl and Ql computation (shunts only)
obj.DAE.g = zeros(obj.DAE.m,1);
obj.fm_call('load0');
obj.Bus.obj.Pl = obj.DAE.g(obj.Bus.a);
obj.Bus.Ql = obj.DAE.g(obj.Bus.v);

%Pg and Qg computation
obj.fm_call('gen0');
obj.Bus.Pg = obj.DAE.g(obj.Bus.a);
obj.Bus.Qg = obj.DAE.g(obj.Bus.v);
if ~obj.Settings.distrsw
  obj.SW = setpg(obj.SW,'all',obj.Bus.Pg(obj.SW.bus));
end

% adjust powers in case of obj.PQ generators
adjgen(obj.PQ)

% memory allocation for dynamic variables & state variables indicization
if nodyn == 1; obj.DAE.x = []; obj.DAE.f = []; obj.DAE.n = 0; end
obj.DAE.npf = obj.DAE.n;
m_old = obj.DAE.m;
obj.fm_dynidx;

% rebuild algebraic variables and vectors
m_diff = obj.DAE.m-m_old;
if m_diff
  obj.DAE.y = [obj.DAE.y;zeros(m_diff,1)];
  obj.DAE.g = [obj.DAE.g;zeros(m_diff,1)];
  obj.DAE.Gy = sparse(obj.DAE.m,obj.DAE.m);
end

% rebuild state variables and vectors
if obj.DAE.n ~= 0
  obj.DAE.f = [obj.DAE.f; ones(obj.DAE.n-obj.DAE.npf,1)];  % differential equations
  obj.DAE.x = [obj.DAE.x; ones(obj.DAE.n-obj.DAE.npf,1)];  % state variables
  obj.DAE.Fx = sparse(obj.DAE.n,obj.DAE.n); % state Jacobian df/dx
  obj.DAE.Fy = sparse(obj.DAE.n,obj.DAE.m); % state Jacobian df/dy
  obj.DAE.Gx = sparse(obj.DAE.m,obj.DAE.n); % algebraic Jacobian dg/dx
end

%  build cell arrays of variable names
obj.fm_idx(1)
if (obj.Settings.vs == 1), obj.fm_idx(2), end

% initializations of state variables and components
if obj.Settings.static
  fm_disp('* * * Dynamic components are not initialized * * *')
end
if convergence
  obj.Settings.init = 1;
else
  obj.Settings.init = -1;
end
fm_rmgen(-1); % initialize function for removing static generators
obj.fm_call('0'); % compute initial state variables

% power flow result visualization
obj.fm_disp(['Power Flow completed in ',num2str(obj.Settings.lftime),' s'])
if obj.Settings.showlf == 1 || ishandle(obj.Fig.stat)
  fm_stat;
else
  if obj.Settings.beep, beep, end
end
if ishandle(obj.Fig.threed), fm_threed('update'), end

% initialization of all equations & Jacobians
refreshJac(obj)
obj.fm_call('i');

% build structure "obj.Snapshot"
if isempty(obj.Settings.t0) && ishandle(obj.Fig.main)
  hdl = findobj(obj.Fig.main,'Tag','EditText3');
  obj.Settings.t0 = str2num(get(hdl,'String')); %#ok
end

if ~obj.Settings.locksnap && obj.Bus.n <= 5000 && obj.DAE.n < 5000
  obj.Snapshot = struct( ...
      'name','Power Flow Results', ...
      'time',obj.Settings.t0, ...
      'y',obj.DAE.y, ...
      'x',obj.DAE.x,...
      'Ybus',obj.Line.Y, ...
      'Pg',obj.Bus.Pg, ...
      'Qg',obj.Bus.Qg, ...
      'Pl',obj.Bus.Pl, ...
      'Ql',obj.Bus.Ql, ...
      'Gy',obj.DAE.Gy, ...
      'Fx',obj.DAE.Fx, ...
      'Fy',obj.DAE.Fy, ...
      'Gx',obj.DAE.Gx, ...
      'Ploss',sum(obj.Bus.Pg)-sum(obj.Bus.Pl), ...
      'Qloss',sum(obj.Bus.Qg)-sum(obj.Bus.Ql), ...
      'it',1);
else
  if obj.Bus.n > 5000
    obj.fm_disp(['Snapshots are disabled for networks with more than 5000 ' ...
             'buses.'])
  end
  if obj.DAE.n > 5000
    obj.fm_disp(['Snapshots are disabled for networks with more than 5000 ' ...
             'state variables.'])
  end
end

obj.fm_status('pf','close')

obj.LIB.selbus = min(obj.LIB.selbus,obj.Bus.n);
if ishandle(obj.Fig.lib)
  set(findobj(obj.Fig.lib,'Tag','Listbox1'), ...
      'String',obj.Bus.names, ...
      'Value',obj.LIB.selbus);
end


% -----------------------------------------------
function refreshJac(obj)
obj.DAE.g = zeros(obj.DAE.m,1);

% -----------------------------------------------
function refreshGen(obj,nodyn)
if nodyn, obj.DAE.Fx = 1; end
Fxcall(obj.SW,obj,'full')
Fxcall(obj.PV,obj)

% -----------------------------------------------
function inc = calcInc(nodyn,Jrow,obj)
obj.DAE.g = zeros(obj.DAE.m,1);

if obj.Settings.distrsw % distributed slack bus

  obj.fm_call('kgpf');
  if nodyn, obj.DAE.Fx = 1; end
  inc = -[obj.DAE.Fx,obj.DAE.Fy,obj.DAE.Fk;obj.DAE.Gx,obj.DAE.Gy,obj.DAE.Gk;Jrow]\ ...
        [obj.DAE.f; obj.DAE.g; obj.DAE.y(obj.SW.refbus)];

else % single slack bus

  obj.fm_call('l');
  if nodyn, obj.DAE.Fx = 1; end
  Fxcall(obj.SW,obj,'full')
  Fxcall(obj.PV,obj)
  inc = -[obj.DAE.Fx, obj.DAE.Fy; obj.DAE.Gx, obj.DAE.Gy]\[obj.DAE.f; obj.DAE.g];

end
