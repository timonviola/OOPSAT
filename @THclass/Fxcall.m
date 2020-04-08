function Fxcall(a,psat_obj)

if ~a.n, return, end

T = psat_obj.DAE.x(a.T);
x = psat_obj.DAE.x(a.x);
G = psat_obj.DAE.y(a.G);
V = a.u.*psat_obj.DAE.y(a.vbus);
Kp = a.u.*a.con(:,3);
Ki = a.u.*a.con(:,4);
Ti = a.con(:,5);
T1 = a.con(:,6);
Ta = a.con(:,7);
Tref = a.con(:,8);
G_max = a.con(:,9);
K1 = a.con(:,10);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.T,a.T,a.u./T1,psat_obj.DAE.n,psat_obj.DAE.n);
z = x < G_max & x > 0 & a.u;
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.x,a.T,z.*Ki./Ti,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.T,a.G,K1.*V.^2./T1,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.T,a.vbus,2*K1.*G.*V./T1,psat_obj.DAE.n,psat_obj.DAE.m);

z = G < G_max & G > 0 & a.u;
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.G,a.T,a.u.*Kp.*z,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.G,a.x,z,psat_obj.DAE.m,psat_obj.DAE.n);
