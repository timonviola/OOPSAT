function Gycall(a,psat_obj)

if ~a.n, return, end

V = a.u.*psat_obj.DAE.y(a.vbus);

psat_obj.DAE.Gy = psat_obj.DAE.Gy ... 
  + sparse(a.bus,a.vbus,2*psat_obj.DAE.y(a.G).*V,psat_obj.DAE.m,psat_obj.DAE.m) ...
  - sparse(a.G,a.G,a.u,psat_obj.DAE.m,psat_obj.DAE.m) ...
  + sparse(a.bus,a.G,V.*V,psat_obj.DAE.m,psat_obj.DAE.m);
