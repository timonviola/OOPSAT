function a = intervention(a,t,psat_obj)

if ~a.n, return, end

% do not repeat computations if the simulation is stucking
if a.time ~= t
  a.time = t;
else
  return
end

% Toggle Breaker Status

action = {'Opening','Closing'};
idx = [find(a.t1 == t); find(a.t2 == t)];

if ~isempty(idx)

  a.u(idx) = ~a.u(idx);
  for i = 1:length(idx)
    k = idx(i);
    fm_disp([action{a.u(k)+1},' breaker at bus <', ...
             psat_obj.Bus.names{a.bus(k)}, ...
             '> on line from <', ...
             psat_obj.Bus.names{psat_obj.Line.fr(a.line(k))}, ...
             '> to <', ...
             psat_obj.Bus.names{psat_obj.Line.to(a.line(k))}, ...
             '> for t = ',num2str(t),' s'])
    
    % update psat_obj.Line data and admittance matrix
    psat_obj.Line = setstatus(psat_obj.Line,a.line(k),a.u(k));
    
    % update algebraic variables
    %conv = fm_nrlf(40,1e-4,1,1);
  
    % checking network connectivity
    fm_flows(psat_obj,'connectivity','verbose');

  end
end
