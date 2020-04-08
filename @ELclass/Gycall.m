function Gycall(a,psat_obj)

if ~a.n, return, end

V  = psat_obj.DAE.y(a.vbus);
at = a.con(:,8);
bt = a.con(:,10);
P0 = a.dat(:,1);
Q0 = a.dat(:,2);
V0 = a.dat(:,3);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.vbus,a.u.*P0.* ...
                           (V./V0).^(at-1).*at./V0,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.vbus,a.u.*Q0.* ...
                           (V./V0).^(bt-1).*bt./V0,psat_obj.DAE.m,psat_obj.DAE.m);
