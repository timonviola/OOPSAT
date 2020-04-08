function a = setx0(a,psat_obj)

if ~a.n, return, end

% variable initialization
psat_obj.DAE.x(a.Vs) = 0;
Vs = psat_obj.DAE.x(a.Vs);

% check time constants
idx = find(a.con(:,4) == 0);
if idx
  warn(a,idx,'Time constant T cannot be zero. T = 0.001 s will be used.')
end
a.con(idx,4) = 0.001;

% Reactive power reference
a.con(:,7) = psat_obj.DAE.y(a.q);

a.dVsdQ = (a.con(:,5)+a.con(:,6))./a.con(:,4);
%a.u = ones(a.n,1);

% check limits
idx = find(Vs > a.con(:,8));
if idx
  warn(a,idx,' State variable Vs is over its maximum limit.')
end
idx = find(Vs < a.con(:,9));
if idx
  warn(a,idx,' State variable Vs is under its minimum limit.')
end

psat_obj.fm_disp('Initialization of Cluster Controllers completed.')
  
