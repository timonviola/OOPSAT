function fcall(a,psat_obj)

if ~a.n, return, end

id = psat_obj.DAE.x(a.Id);
iq = psat_obj.DAE.x(a.Iq);
If = psat_obj.DAE.x(a.If);
ed = psat_obj.DAE.x(a.Edc);
eq = psat_obj.DAE.x(a.Eqc);
w1 = psat_obj.DAE.x(a.omega_HP);
w2 = psat_obj.DAE.x(a.omega_IP);
w3 = psat_obj.DAE.x(a.omega_LP);
w4 = psat_obj.DAE.x(a.omega);
w5 = psat_obj.DAE.x(a.omega_EX);
t1 = psat_obj.DAE.x(a.delta_HP);
t2 = psat_obj.DAE.x(a.delta_IP);
t3 = psat_obj.DAE.x(a.delta_LP);
t4 = psat_obj.DAE.x(a.delta);
t5 = psat_obj.DAE.x(a.delta_EX);

xd  = a.con(:,5);
xq  = a.con(:,6);
xad = a.con(:,8);
xf  = a.con(:,13);

xl  = a.con(:,10);
xc  = a.con(:,11);
xeq = xad.*xad-xf.*(xd+xl);

rf  = a.con(:,12);
ra  = a.con(:,7);
r   = a.con(:,9);

D1 = a.con(:,19);
D2 = a.con(:,20);
D3 = a.con(:,21);
D4 = a.con(:,22);
D5 = a.con(:,23);

iM1 = a.u./a.con(:,14);
iM2 = a.u./a.con(:,15);
iM3 = a.u./a.con(:,16);
iM4 = a.u./a.con(:,17);
iM5 = a.u./a.con(:,18);

k12 = a.con(:,24);
k23 = a.con(:,25);
k34 = a.con(:,26);
k45 = a.con(:,27);

Tm  = a.Tm;
Efd = a.Efd;
Wbu = 2*pi*psat_obj.Settings.freq*a.u;

V = psat_obj.DAE.y(a.vbus);
theta = psat_obj.DAE.y(a.bus);
cdt = cos(t4-theta);
sdt = sin(t4-theta);

Te = ((xq-xd).*id+xad.*If).*iq;
B = Wbu.*((ra+r).*id-(xl+w4.*xq).*iq+ed+V.*sdt);
C = Wbu.*(rf.*Efd./xad-rf.*If);

psat_obj.DAE.f(a.Id) = (xf.*B-xad.*C)./xeq;
psat_obj.DAE.f(a.Iq) = -Wbu.*((xl+w4.*xd).*id+(ra+r).*iq-w4.*xad.*If+eq+V.*cdt)./(xq+xl);
psat_obj.DAE.f(a.If) = (xad.*B-(xd+xl).*C)./xeq;
psat_obj.DAE.f(a.Edc) = Wbu.*(xc.*id+eq);
psat_obj.DAE.f(a.Eqc) = Wbu.*(xc.*iq-ed);
psat_obj.DAE.f(a.omega_HP) = (Tm-D1.*(w1-1)+k12.*(t2-t1)).*iM1;
psat_obj.DAE.f(a.omega_IP) = (-D2.*(w2-1)+k12.*(t1-t2)+k23.*(t3-t2)).*iM2;
psat_obj.DAE.f(a.omega_LP) = (-D3.*(w3-1)+k23.*(t2-t3)+k34.*(t4-t3)).*iM3;
psat_obj.DAE.f(a.omega) = (-Te-D4.*(w4-1)+k34.*(t3-t4)+k45.*(t5-t4)).*iM4;
psat_obj.DAE.f(a.omega_EX) = (-D5.*(w5-1)+k45.*(t4-t5)).*iM5;
psat_obj.DAE.f(a.delta_HP) = Wbu.*(w1-1);
psat_obj.DAE.f(a.delta_IP) = Wbu.*(w2-1);
psat_obj.DAE.f(a.delta_LP) = Wbu.*(w3-1);
psat_obj.DAE.f(a.delta)    = Wbu.*(w4-1);
psat_obj.DAE.f(a.delta_EX) = Wbu.*(w5-1);
