function fcall(a,psat_obj)

if ~a.n, return, end

omega_m = psat_obj.DAE.x(a.omega_m);
theta_p = psat_obj.DAE.x(a.theta_p);
iqs = psat_obj.DAE.x(a.iqs);
idc = psat_obj.DAE.x(a.idc);
vw = psat_obj.DAE.x(getidx(psat_obj.Wind,a.wind));
rho = getrho(psat_obj.Wind,a.wind);

pwa = psat_obj.DAE.y(a.pwa);
ids = psat_obj.DAE.y(a.ids);
V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);

rs = a.con(:,6);
xd = a.con(:,7);
xq = a.con(:,8);
psip = a.con(:,9);

Hm = a.con(:,10);
Kp = a.con(:,11);
Tp = a.con(:,12);
Kv = a.con(:,13);
Tv = a.con(:,14);
Tep = a.con(:,15);
% Teq = a.con(:,16);
R = a.dat(:,1);
A = a.dat(:,2);
Vref = a.dat(:,3);
ng = a.con(:,25);
iomega = 1./(~a.u+omega_m);

vds = -rs.*ids+omega_m.*xq.*iqs;
vqs = -rs.*iqs-omega_m.*(xd.*ids-psip);
ps = vds.*ids+vqs.*iqs;
qc = (V.*idc+st.*ps)./ct;
uq = qc < a.con(:,23) & qc > a.con(:,24);

% wind speed in m/s
Vw = vw.*getvw(psat_obj.Wind,a.wind);

% mechanical torque
Pw = ng.*windpower(a,rho,Vw,A,R,~a.u+omega_m,theta_p,1)/psat_obj.Settings.mva/1e6;
Tm = Pw.*iomega;

% motion equation
psat_obj.DAE.f(a.omega_m) = 0.5*a.u.*(Tm-(psip-xd.*ids).*iqs-xq.*iqs.*ids)./Hm;

% pitch control equation
% vary the pitch angle only by steps of 1% of the fn
phi = round(1000*(~a.u+omega_m-1))/1000;
psat_obj.DAE.f(a.theta_p) = (Kp.*phi-theta_p)./Tp;

% voltage control equation
psat_obj.DAE.f(a.idc) = uq.*a.u.*(-idc+Kv.*(Vref-V))./Tv;

% speed control equations
% Pm = a.con(:,3).*max(min(2*omega_m-1,1),0)/psat_obj.Settings.mva;
psat_obj.DAE.f(a.iqs) = a.u.*(pwa./(psip-xd.*ids).*iomega-iqs)./Tep;

% anti-windup limiter
fm_windup(a.idc,a.con(:,23),a.con(:,24),'f',psat_obj)
fm_windup(a.iqs,a.con(:,21),a.con(:,22),'f',psat_obj)
fm_windup(a.theta_p,Inf,0,'f',psat_obj)
