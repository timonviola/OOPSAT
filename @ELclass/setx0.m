function a = setx0(a,psat_obj)

if ~a.n, return, end

% parameter initialization

% dat:
%  col #1: P0
%  col #2: Q0
%  col #3: V0

a.dat(:,3) = psat_obj.DAE.y(a.vbus);

for k = 1:a.n
  idx = findbus(psat_obj.PQ,a.bus(k));
  if isempty(idx)
    fm_disp(['No psat_obj.PQ load found for initializing Exponential ', ...
             'Recovery Load at bus ',psat_obj.Bus.names{a.bus(k)}])
  else
    a.dat(k,1) = a.u(k)*psat_obj.PQ.P0(idx)*a.con(k,3)/100;
    a.dat(k,2) = a.u(k)*psat_obj.PQ.Q0(idx)*a.con(k,4)/100;
    psat_obj.PQ = pqsub(psat_obj.PQ,idx,a.dat(k,1),a.dat(k,2));
    psat_obj.PQ = remove(psat_obj.PQ,idx,'zero');
  end
end

% state variable initialization
psat_obj.DAE.x(a.xp) = 0;
psat_obj.DAE.x(a.xq) = 0;

% message
psat_obj.fm_disp('Initialization of Exponential Recovery Loads completed.')

