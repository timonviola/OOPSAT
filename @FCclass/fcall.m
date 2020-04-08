function fcall(a,psat_obj)

if ~a.n, return, end

Ik = psat_obj.DAE.x(a.Ik);
Vk = psat_obj.DAE.x(a.Vk);
pH2 = psat_obj.DAE.x(a.pH2);
pH2O = psat_obj.DAE.x(a.pH2O);
pO2 = psat_obj.DAE.x(a.pO2);
qH2 = psat_obj.DAE.x(a.qH2);
m = psat_obj.DAE.x(a.m);
Sn = a.con(:,2);
Vn = a.con(:,3);
Te = a.con(:,4);
TH2 = a.con(:,5);
KH2 = a.con(:,6);
Kr = a.con(:,7);
TH2O = a.con(:,8);
KH2O = a.con(:,9);
TO2 = a.con(:,10);
KO2 = a.con(:,11);
rHO = a.con(:,12);
Tf = a.con(:,13);
Uopt = a.con(:,14);
r = a.con(:,17);
N0 = a.con(:,18);
E0 = a.con(:,19);
RTon2F = a.con(:,20);
Vref = a.con(:,22);
xt = a.con(:,26);
Km = a.con(:,27);
Tm = a.con(:,28);
mmax = a.con(:,29);
mmin = a.con(:,30);
logarg = a.u.*(pH2.*sqrt(pO2)./(pH2O+(~a.u))) + (~a.u);
[Input,Umax,Umin] = fcinput(a);

Input = min(Input,Umax);
Input = max(Input,Umin);

psat_obj.DAE.f(a.Ik) = a.u.*(Input-Ik)./Te;
psat_obj.DAE.f(a.Vk) = 1e3*a.u.*(-Vk-r.*Ik./Vn+N0.*(E0+RTon2F.*log(logarg))./Vn);
psat_obj.DAE.f(a.pH2) = a.u.*((qH2-2.*Kr.*Ik)./KH2-pH2)./TH2;
psat_obj.DAE.f(a.pH2O) = a.u.*(2.*Kr.*Ik./KH2O-pH2O)./TH2O;
psat_obj.DAE.f(a.pO2) = a.u.*((qH2./rHO-Kr.*Ik)./KO2-pO2)./TO2;
psat_obj.DAE.f(a.qH2) = a.u.*(2.*Kr.*Ik./Uopt-qH2)./Tf;
psat_obj.DAE.f(a.m) = a.u.*(Km.*(Vref-psat_obj.DAE.y(a.vbus))-m)./Tm;

% anti-windup limiter
fm_windup(a.m,a.con(:,29),a.con(:,30),'f',psat_obj)
