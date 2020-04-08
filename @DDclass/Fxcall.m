function Fxcall(a,psat_obj)

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
ng = a.con(:,25);

qc_max = a.con(:,23);
qc_min = a.con(:,24);
iqs_max = a.con(:,21);
iqs_min = a.con(:,22);

w = ~a.u+omega_m;
Vwrate = getvw(psat_obj.Wind,a.wind);
Vw = vw.*Vwrate;
dPwdx = windpower(a,rho,Vw,A,R,w,theta_p,2)./psat_obj.Settings.mva/1e6;
Pw = ng.*windpower(a,rho,Vw,A,R,w,theta_p,1)/psat_obj.Settings.mva/1e6;
Tm = Pw./w;
Tsp = a.con(:,3).*min(2*omega_m-1,1)./w/psat_obj.Settings.mva;
Tsp = max(Tsp,0);
i2Hm = 0.5*a.u./Hm;

c1 = cos(t);
s1 = sin(t);
t1 = s1./c1;
k1 = psip-xd.*ids;
k2 = xq.*iqs;
k3 = xd.*iqs;
k4 = xq.*ids;
k5 = rs.*ids;
k6 = rs.*iqs;

vds = -rs.*ids+omega_m.*xq.*iqs;
vqs = -rs.*iqs-omega_m.*(xd.*ids-psip);
ps = vds.*ids+vqs.*iqs;
iq = (ps + V.*s1.*idc)./V./c1;
uc = iq < iqs_max & iq > iqs_min;
qc = V.*(idc.*c1+iq.*s1);
uq = qc < qc_max & qc > qc_min;

% mechanical equation
% -------------------

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_m,a.omega_m,(ng.*dPwdx(:,1)-Tm).*i2Hm./w-(~a.u),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_m,getidx(psat_obj.Wind,a.wind),Vwrate.*ng.*dPwdx(:,2).*i2Hm./w,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.omega_m,a.ids,i2Hm.*(k3-k2),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.omega_m,k2.*ids+k1.*iqs,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.ids,a.omega_m,k1.*ids-k2.*iqs,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.iqc,a.omega_m,uc.*(k1.*iqs+k2.*ids)./V./c1,psat_obj.DAE.m,psat_obj.DAE.n);

% voltage control
% ---------------

z = idc > qc_min & idc < qc_max & a.u;

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.idc,a.idc,1./Tv,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.idc,uq.*z.*V.*c1,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.idc,a.vbus,z.*Kv./Tv,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.iqc,a.idc,uc.*z.*t1,psat_obj.DAE.m,psat_obj.DAE.n);

% speed control
% -------------

z = iqs > iqs_min & iqs < iqs_max & a.u;

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.iqs,a.iqs,1./Tep,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.iqs,a.omega_m,z.*pwa./k1./w./w./Tep,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.iqs,a.pwa,z./k1./w./Tep,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.iqs,a.ids,z.*pwa.*xd./(k1.^2)./w./Tep,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_m,a.iqs,z.*(k1+k4).*i2Hm,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.iqs,z.*(w.*k4-2.*k6+w.*k1),psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.iqc,a.iqs,uc.*z.*(omega_m.*(k1+k4)-2*k6)./V./c1,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.ids,a.iqs,2*z.*omega_m.*k2,psat_obj.DAE.m,psat_obj.DAE.n);

% psat_obj.DAE.f(a.iqs) = a.u.*(pwa./(psip-xd.*ids).*iomega-iqs)./Tep;

% pitch angle control equation
% ----------------------------

z = theta_p > 0 & a.u;

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.theta_p,a.theta_p,1./Tp,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.theta_p,a.omega_m,z.*Kp./Tp,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_m,a.theta_p,z.*ng.*dPwdx(:,3).*i2Hm./w,psat_obj.DAE.n,psat_obj.DAE.n);

% power reference
% ---------------

z = a.u & omega_m > 0.5 & omega_m < 1.0;

psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.pwa, a.omega_m, 2*z.*a.con(:,3)/psat_obj.Settings.mva, psat_obj.DAE.m, psat_obj.DAE.n);
