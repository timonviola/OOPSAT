function pqsum(a,lambda,psat_obj)


if ~a.n, return, end

tgd = tanphi(a);

for i = 1:a.n
  idx = findbus(psat_obj.PQ,a.bus(i));
  pd = lambda*a.u(i)*a.con(i,7);
  qd = lambda*a.u(i)*tgd(i)*a.con(i,7);
  psat_obj.PQ = pqsum(psat_obj.PQ,idx,pd,qd);
end

