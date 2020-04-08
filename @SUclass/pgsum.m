function pgsum(a,k,psat_obj)

if ~a.n, return, end

for i = 1:a.n
  idx = findbus(psat_obj.PV,a.bus(i));
  psat_obj.PV = pvsum(psat_obj.PV,idx,k*a.u(i)*a.con(i,6));
end

