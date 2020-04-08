function Gycall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.Gy = psat_obj.DAE.Gy ...
         - sparse(a.delta,a.delta,1,psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.omega,a.omega,1,psat_obj.DAE.m,psat_obj.DAE.m);
