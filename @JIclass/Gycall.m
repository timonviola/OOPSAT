function Gycall(a,psat_obj)

if ~a.n, return, end

V1 = psat_obj.DAE.y(a.vbus);
Tf = a.con(:,5);
Plz = a.con(:,6);
Pli = a.con(:,7);
Qlz = a.con(:,9);
Qli = a.con(:,10);
Kv = a.con(:,12);
V1_0 = a.dat(:,1);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.vbus, ...
                           a.u.*(2.*Plz.*V1./V1_0.^2+Pli./V1_0),psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.vbus, ...
                           a.u.*(2.*Qlz.*V1./V1_0.^2+Qli./V1_0+Kv./Tf),psat_obj.DAE.m,psat_obj.DAE.m);
