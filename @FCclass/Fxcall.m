function Fxcall(a,psat_obj)

if ~a.n, return, end

Ik = psat_obj.DAE.x(a.Ik);
Vk = psat_obj.DAE.x(a.Vk) + (~a.u);
Vs = psat_obj.DAE.y(a.vbus);
pH2 = psat_obj.DAE.x(a.pH2) + (~a.u);
pH2O = psat_obj.DAE.x(a.pH2O) + (~a.u);
pO2 = psat_obj.DAE.x(a.pO2) + (~a.u);
qH2 = psat_obj.DAE.x(a.qH2);
m = psat_obj.DAE.x(a.m);
Sn = a.con(:,2);
Vn = a.con(:,3);
Te = a.con(:,4);
TH2 = a.con(:,5);
KH2 = a.con(:,6);
Kr = a.u.*a.con(:,7);
iKr = 1./a.con(:,7);
TH2O = a.con(:,8);
KH2O = a.con(:,9);
TO2 = a.con(:,10);
KO2 = a.con(:,11);
rHO = a.con(:,12);
Tf = a.con(:,13);
Uopt = a.con(:,14);
r = a.u.*a.con(:,17);
N0 = a.u.*a.con(:,18);
E0 = a.con(:,19);
RTon2F = a.con(:,20);
xt = a.con(:,26);
Km = a.con(:,27);
Tm = a.con(:,28);
Pref = a.con(:,21).*a.con(:,23);
u = m < a.con(:,29) & m > a.con(:,30) & a.u;
Vt = m.*Vk.*a.con(:,24);
[Input,Umax,Umin] = fcinput(a);

sq = sqrt(1-(xt.*Ik./Vs.*Vn./Sn./m).^2);
dQdi = 0.5*Vs.*Vt./xt.*(-2*((xt.*Vn./Sn./m./Vs).^2).*Ik)./sq;
dQdv = m.*a.con(:,24).*Vs./xt.*sq;
dQdm = Vk.*a.con(:,24).*Vs./xt.*sq + ...
       0.5*Vs.*Vt./xt.*(2*((xt.*Ik.*Vn./Sn./Vs).^2)./(m.^3))./sq;

u1 = (Input > Umax | Input < Umin) & a.u;
u2 = ~u1 & ~a.con(:,25) & a.u;

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Ik,a.Ik,1./Te,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Vk,a.Vk,1e3,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.m,a.m,1./Tm,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.pH2,a.pH2,1./TH2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.pH2O,a.pH2O,1./TH2O,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.qH2,a.qH2,1./Tf,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.pO2,a.pO2,1./TO2,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Ik,a.qH2,0.5*u1.*a.con(:,16).*iKr,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Ik,a.Vk,u2.*Sn.*Pref./(Vk.^2)./Vn./Te,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Vk,a.Ik,1e3*r./Vn,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Vk,a.pH2,1e3*N0.*RTon2F./pH2./Vn,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Vk,a.pH2O,1e3*N0.*RTon2F./pH2O./Vn,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Vk,a.pO2,1e3*0.5*N0.*RTon2F./pO2./Vn,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.pH2,a.Ik,2.*Kr./KH2./TH2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.pH2,a.qH2,a.u./KH2./TH2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.pH2O,a.Ik,2.*Kr./KH2O./TH2O,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.pO2,a.Ik,Kr./KO2./TO2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.pO2,a.qH2,a.u./rHO./KO2./TO2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.qH2,a.Ik,2.*Kr./Uopt./Tf,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.m,a.vbus,u.*Km./Tm,psat_obj.DAE.n,psat_obj.DAE.m);

psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.Vk,a.u.*dQdv,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.Ik,a.u.*dQdi,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.m,u.*dQdm,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.Ik,a.u.*Vk.*Vn./Sn.*a.con(:,24),psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.Vk,a.u.*Ik.*Vn./Sn.*a.con(:,24),psat_obj.DAE.m,psat_obj.DAE.n);
