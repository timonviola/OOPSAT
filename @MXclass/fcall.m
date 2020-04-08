function fcall(a,psat_obj)
if ~a.n, return, end

x = psat_obj.DAE.x(a.x);
y = psat_obj.DAE.x(a.y);
V1 = psat_obj.DAE.y(a.vbus);
t1 = psat_obj.DAE.y(a.bus);
Tfv = a.con(:,13);
Tft = a.con(:,14);
k = 0.5/pi/psat_obj.Settings.freq;
V0 = a.dat(:,1);
t0 = a.dat(:,2);

psat_obj.DAE.f(a.x) = a.u.*(-V1./Tfv-x)./Tfv;
psat_obj.DAE.f(a.y) = a.u.*(-k.*(t1-t0)./Tft-y)./Tft;
