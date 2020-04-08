function Gycall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vref,a.vref,1,psat_obj.DAE.m,psat_obj.DAE.m);
