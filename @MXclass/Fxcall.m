function Fxcall(a,psat_obj)

if ~a.n, return, end

Kpf = a.con(:,5);
Kpv = a.con(:,6);
Tpv = a.con(:,8);
Kqf = a.con(:,9);
Kqv = a.con(:,10);
Tpv = a.con(:,8);
Tqv = a.con(:,12);
Tfv = a.con(:,13);
Tft = a.con(:,14);
k = 0.5/pi/psat_obj.Settings.freq;

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.x,a.x,-a.u./Tfv,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.y,a.y,-a.u./Tft,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.x,a.vbus,-a.u./Tfv./Tfv,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.y,a.bus,-k*a.u./Tft./Tft,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.bus,a.x,a.u.*Kpv.*Tpv,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.bus,a.y,a.u.*Kpf,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vbus,a.x,a.u.*Kqv.*Tqv,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vbus,a.y,a.u.*Kqf,psat_obj.DAE.m,psat_obj.DAE.n);
