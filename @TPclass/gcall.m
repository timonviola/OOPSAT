function gcall(a,psat_obj)

if ~a.n, return, end

m = psat_obj.DAE.x(a.m);
V = psat_obj.DAE.y(a.vbus);

psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.bus,1,a.u.*a.con(:,9).*((V./m).^a.con(:,11)),psat_obj.DAE.m,1) ...
        + sparse(a.vbus,1,a.u.*a.con(:,10).*((V./m).^a.con(:,12)),psat_obj.DAE.m,1);
