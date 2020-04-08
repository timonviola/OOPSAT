function Fxcall(a,psat_obj)


if ~a.n, return, end

xp = psat_obj.DAE.x(a.xp);
xq = psat_obj.DAE.x(a.xq);
V = psat_obj.DAE.y(a.vbus);
Tp = a.con(:,5);
Tq = a.con(:,6);
as = a.con(:,7);
at = a.con(:,8);
bs = a.con(:,9);
bt = a.con(:,10);
P0 = a.u.*a.dat(:,1);
Q0 = a.u.*a.dat(:,2);
V0 = a.dat(:,3);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.xp,a.xp,a.u./Tp,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.xq,a.xq,a.u./Tq,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.xp,a.vbus, ...
                         P0.*(V./V0).^(as-1).*as./V0 - P0.*(V./V0).^(at-1).*at./V0, ...
                         psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.xq,a.vbus, ...
                         Q0.*(V./V0).^(bs-1).*bs./V0 - Q0.*(V./V0).^(bt-1).*bt./V0, ...
                         psat_obj.DAE.n,psat_obj.DAE.m);

psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.bus,a.xp,a.u./Tp,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vbus,a.xq,a.u./Tq,psat_obj.DAE.m,psat_obj.DAE.n);
