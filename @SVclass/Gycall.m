function Gycall(a,psat_obj)

if ~a.n, return, end

V = a.u.*psat_obj.DAE.y(a.vbus);

psat_obj.DAE.Gy = psat_obj.DAE.Gy ...
         - sparse(a.vbus,a.q,1,psat_obj.DAE.m,psat_obj.DAE.m) ...
         + sparse(a.q,a.vbus,2*a.Be.*V,psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.q,a.q,1,psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.vref,a.vref,1,psat_obj.DAE.m,psat_obj.DAE.m);
