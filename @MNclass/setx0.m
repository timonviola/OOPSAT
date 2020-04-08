function a = setx0(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);

i = find(a.con(:,8));
for j = 1:length(i)
  k = i(j);
  idx = findbus(psat_obj.PQ,a.bus(k));
  if isempty(idx),
    fm_disp(['No psat_obj.PQ load found for initializing monomial ', ...
             'load at bus ',psat_obj.Bus.names{a.bus(k)}])
  else
    P = a.u(k)*psat_obj.PQ.P0(idx)*a.con(k,4)/100;
    Q = a.u(k)*psat_obj.PQ.Q0(idx)*a.con(k,5)/100;
    psat_obj.PQ = pqsub(psat_obj.PQ,idx,P,Q);
    a.con(k,4)  = a.con(k,4)*psat_obj.PQ.P0(idx)/(V(k)^a.con(k,6))/100;
    a.con(k,5)  = a.con(k,5)*psat_obj.PQ.Q0(idx)/(V(k)^a.con(k,7))/100;
    psat_obj.PQ = remove(psat_obj.PQ,idx,'zero');
  end
end

fm_disp('Initialization of Monomial Loads completed.')
