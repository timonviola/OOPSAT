function gcall(a,psat_obj)

if ~a.n, return, end

Ik = psat_obj.DAE.x(a.Ik);
Vk = psat_obj.DAE.x(a.Vk);
m = psat_obj.DAE.x(a.m);
Vs = psat_obj.DAE.y(a.vbus);
Sn = a.con(:,2);
Vn = a.con(:,3);
Vbas = a.con(:,24);
xt = a.con(:,26);

psat_obj.DAE.g = psat_obj.DAE.g - sparse(a.bus,1,a.u.*Ik.*Vk.*Vn./Sn.*Vbas,psat_obj.DAE.m,1);
Vt = m.*Vk.*Vbas;
Q = -Vs.*(Vs - Vt.*sqrt(1-(xt.*Ik./Vs.*Vn./Sn./m).^2))./xt;
psat_obj.DAE.g = psat_obj.DAE.g - sparse(a.vbus,1,a.u.*Q,psat_obj.DAE.m,1);
