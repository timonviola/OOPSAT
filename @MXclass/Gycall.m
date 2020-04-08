function Gycall(a,psat_obj)

if ~a.n, return, end

V1 = psat_obj.DAE.y(a.vbus);
Kpf = a.con(:,5);
Kpv = a.con(:,6);
alpha = a.con(:,7);
Tpv = a.con(:,8);
Kqf = a.con(:,9);
Kqv = a.con(:,10);
beta = a.con(:,11);
Tqv = a.con(:,12);
Tfv = a.con(:,13);
Tft = a.con(:,14);
k = 0.5/pi/psat_obj.Settings.freq;
V0 = a.dat(:,1);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.vbus,a.u.*Kpv.*((V1./V0).^alpha.*alpha./V1+Tpv./Tfv),psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.bus,a.u.*Kpf.*k./Tft,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.vbus,a.u.*Kqv.*((V1./V0).^beta.*beta./V1+Tqv./Tfv),psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.bus,a.u.*Kqf.*k./Tft,psat_obj.DAE.m,psat_obj.DAE.m);
