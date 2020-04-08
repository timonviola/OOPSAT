function Gycall(p,psat_obj)

if ~p.n, return, end

V = 2*p.u.*psat_obj.DAE.y(p.vbus);

psat_obj.DAE.Gy  = psat_obj.DAE.Gy + ...
          sparse(p.bus, p.vbus,p.con(:,5).*V,psat_obj.DAE.m,psat_obj.DAE.m) - ...
          sparse(p.vbus,p.vbus,p.con(:,6).*V,psat_obj.DAE.m,psat_obj.DAE.m);

