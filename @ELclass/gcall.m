function gcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
xp = psat_obj.DAE.x(a.xp);
xq = psat_obj.DAE.x(a.xq);
Tp = a.con(:,5);
Tq = a.con(:,6);
at = a.con(:,8);
bt = a.con(:,10);
P0 = a.dat(:,1);
Q0 = a.dat(:,2);
V0 = a.dat(:,3);

psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.bus,1,a.u.*(xp./Tp+P0.*(V./V0).^at),psat_obj.DAE.m,1) ...
        + sparse(a.vbus,1,a.u.*(xq./Tq+Q0.*(V./V0).^bt),psat_obj.DAE.m,1);
