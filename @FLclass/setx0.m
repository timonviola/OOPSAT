function a = setx0(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);

for i = 1:a.n
  idx = findbus(psat_obj.PQ,a.bus(i));
  if isempty(idx)
    fm_disp(['No psat_obj.PQ load found for initializing frequency ', ...
             'dependent load at bus ',psat_obj.Bus.names{a.bus(i)}])
  else
    P = a.u(i)*psat_obj.PQ.P0(idx)*a.con(i,2)/100;
    Q = a.u(i)*psat_obj.PQ.Q0(idx)*a.con(i,5)/100;
    psat_obj.PQ = pqsub(psat_obj.PQ,idx,P,Q);
    a.con(i,2) = a.con(i,2)*psat_obj.PQ.P0(idx)/(V(i)^a.con(i,3))/100;
    a.con(i,5) = a.con(i,5)*psat_obj.PQ.Q0(idx)/(V(i)^a.con(i,6))/100;
    psat_obj.PQ = remove(psat_obj.PQ,idx,'zero');
  end
end
psat_obj.DAE.x(a.x) = 0;
psat_obj.DAE.y(a.dw) = 0;
a.a0 = psat_obj.DAE.y(a.bus);

%check limits
fm_disp('Initialization of Frequency Dependent Loads completed.')
