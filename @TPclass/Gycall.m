function Gycall(a,psat_obj)

if ~a.n, return, end

m = psat_obj.DAE.x(a.m);
V = psat_obj.DAE.y(a.vbus);
a1 = a.con(:,11);
a2 = a.con(:,12);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.vbus, ...
          a.u.*a.con(:,9).*a1.*(V.^(a1-1))./(m.^a1),psat_obj.DAE.m,psat_obj.DAE.m);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.vbus, ...
          a.u.*a.con(:,10).*a2.*(V.^(a2-1))./(m.^a2),psat_obj.DAE.m,psat_obj.DAE.m);

