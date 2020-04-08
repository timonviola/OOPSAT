function Gycall(a,psat_obj)

if ~a.n, return, end

Ik = psat_obj.DAE.x(a.Ik);
Vk = psat_obj.DAE.x(a.Vk);
m = psat_obj.DAE.x(a.m);
Vs = psat_obj.DAE.y(a.vbus);
Sn = a.con(:,2);
Vn = a.con(:,3);
xt = a.con(:,26);

Vt = m.*Vk.*a.con(:,24);
sq = sqrt(1-(xt.*Ik./Vs.*Vn./Sn./m).^2);
dQdv = -2*Vs./xt+Vt./xt.*sq+0.5*Vs.*Vt./xt.*(2*((xt.*Ik.*Vn./Sn./m).^2)./(Vs.^3))./sq;
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vbus,a.vbus,a.u.*dQdv,psat_obj.DAE.m,psat_obj.DAE.m);
