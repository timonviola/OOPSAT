function a = setx0(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);

i = find(a.con(:,11));
for j = 1:length(i)
  k = i(j);
  idx = findbus(psat_obj.PQ,a.bus(k));
  if isempty(idx)
    psat_obj.fm_disp(['No psat_obj.PQ load found for initializing ZIP load ', ...
             'at bus ',psat_obj.Bus.names{a.bus(k)}])
  else
    P = a.u(k)*psat_obj.PQ.P0(idx)*sum(a.con(k,[5:7]))/100;
    Q = a.u(k)*psat_obj.PQ.Q0(idx)*sum(a.con(k,[8:10]))/100;
    psat_obj.PQ = pqsub(psat_obj.PQ,idx,P,Q);
    a.con(k,5)  = a.con(k,5)*psat_obj.PQ.P0(idx)/V(k)/V(k)/100;
    a.con(k,6)  = a.con(k,6)*psat_obj.PQ.P0(idx)/V(k)/100;
    a.con(k,7)  = a.con(k,7)*psat_obj.PQ.P0(idx)/100;
    a.con(k,8)  = a.con(k,8)*psat_obj.PQ.Q0(idx)/V(k)/V(k)/100;
    a.con(k,9)  = a.con(k,9)*psat_obj.PQ.Q0(idx)/V(k)/100;
    a.con(k,10) = a.con(k,10)*psat_obj.PQ.Q0(idx)/100;
    psat_obj.PQ = remove(psat_obj.PQ,idx,'zero');
  end
end

psat_obj.fm_disp('Initialization of ZIP loads completed.')
  
