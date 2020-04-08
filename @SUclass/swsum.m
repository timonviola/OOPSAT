function swsum(a,k,psat_obj)

if ~a.n, return, end

for i = 1:a.n
  idx = findbus(psat_obj.SW,a.bus(i));
  psat_obj.SW = swsum(psat_obj.SW,idx,k*a.con(i,6)*a.u(i));
end
        
