function fcall(a,psat_obj)

if ~a.n, return, end

Wn = 2*pi*psat_obj.Settings.freq;

omega_t = ~a.u+psat_obj.DAE.x(a.omega_t);
omega_m = psat_obj.DAE.x(a.omega_m);
gamma = psat_obj.DAE.x(a.gamma);
e1r = psat_obj.DAE.x(a.e1r);
e1m = psat_obj.DAE.x(a.e1m);

rho = getrho(psat_obj.Wind,a.psat_obj.Wind);

V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);
Vr = -V.*st;
Vm =  V.*ct;

r1 = a.con(:,6);
x0 = a.dat(:,1);
x1 = a.dat(:,2);
iT10 = a.u./a.dat(:,3);
i2Hwr = a.dat(:,4);
i2Hm = a.dat(:,5);
Ks = a.con(:,13);
R = a.dat(:,6);
A = a.dat(:,7);
ng = a.con(:,18);

k = r1.^2+x1.^2;
a13 = r1./k;
a23 = x1./k;
a33 = x0-x1;

Im = -a23.*(e1r-Vr)+a13.*(e1m-Vm);
Ir =  a13.*(e1r-Vr)+a23.*(e1m-Vm);

slip = 1-omega_m;
% periodic torque pulsation due to "tower shadow" phenomenon
omega_r = 2*Wn*omega_t.*a.con(:,17)./a.con(:,15)./a.con(:,16);
shadow = 0.025*sin(max(psat_obj.DAE.t,0)*omega_r);

Vw = psat_obj.DAE.x(getidx(psat_obj.Wind,a.psat_obj.Wind)).*getvw(psat_obj.Wind,a.psat_obj.Wind);
Twr = ng.*psat_obj.Windpower(a,rho,Vw,A,R,omega_t,a.u,1)./omega_t./psat_obj.Settings.mva/1e6;
psat_obj.DAE.f(a.omega_t) = a.u.*(Twr.*(1+shadow)-Ks.*gamma).*i2Hwr;
psat_obj.DAE.f(a.omega_m) = a.u.*(Ks.*gamma-e1r.*Ir-e1m.*Im).*i2Hm;
psat_obj.DAE.f(a.gamma) = Wn*a.u.*(omega_t-omega_m);
psat_obj.DAE.f(a.e1r)  =  Wn*a.u.*slip.*e1m-(e1r-a33.*Im).*iT10;
psat_obj.DAE.f(a.e1m)  = -Wn*a.u.*slip.*e1r-(e1m+a33.*Ir).*iT10;
