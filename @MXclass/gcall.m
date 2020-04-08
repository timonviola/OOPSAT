function gcall(a,psat_obj)

if ~a.n, return, end

x = psat_obj.DAE.x(a.x);
y = psat_obj.DAE.x(a.y);
V1 = psat_obj.DAE.y(a.vbus);
t1 = psat_obj.DAE.y(a.bus);
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
t0 = a.dat(:,2);


psat_obj.DAE.g = psat_obj.DAE.g + ...
        sparse(a.bus,1,a.u.*(Kpf.*(y+k.*(t1-t0)./Tft)+Kpv.*((V1./V0).^alpha+Tpv.*(x+V1./Tfv))),psat_obj.DAE.m,1) + ...
        sparse(a.vbus,1,a.u.*(Kqf.*(y+k.*(t1-t0)./Tft)+Kqv.*((V1./V0).^beta+Tqv.*(x+V1./Tfv))),psat_obj.DAE.m,1);

