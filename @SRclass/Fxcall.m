function Fxcall(a,psat_obj)

if ~a.n, return, end

id = psat_obj.DAE.x(a.Id);
iq = psat_obj.DAE.x(a.Iq);
If = psat_obj.DAE.x(a.If);
ed = psat_obj.DAE.x(a.Edc);
eq = psat_obj.DAE.x(a.Eqc);
w = psat_obj.DAE.x(a.omega);
d = psat_obj.DAE.x(a.delta);

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

D1 = a.u.*a.con(:,19);
D2 = a.u.*a.con(:,20);
D3 = a.u.*a.con(:,21);
D4 = a.u.*a.con(:,22);
D5 = a.u.*a.con(:,23);

M1 = a.con(:,14);
M2 = a.con(:,15);
M3 = a.con(:,16);
M4 = a.con(:,17);
M5 = a.con(:,18);

k12 = a.u.*a.con(:,24);
k23 = a.u.*a.con(:,25);
k34 = a.u.*a.con(:,26);
k45 = a.u.*a.con(:,27);

Tm  = a.Tm;
Efd = a.Efd;
Wb = 2*pi*psat_obj.Settings.freq;
Wbu = Wb*a.u;
notu = ~a.u;

V = a.u.*psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
cdt = cos(d-t);
sdt = sin(d-t);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.delta_HP,a.delta_HP,notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.delta_IP,a.delta_IP,notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.delta_LP,a.delta_LP,notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.delta_EX,a.delta_EX,notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.delta,a.delta,notu,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_HP,a.omega_HP,D1./M1+notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_IP,a.omega_IP,D2./M2+notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_LP,a.omega_LP,D3./M3+notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_EX,a.omega_EX,D5./M5+notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega,a.omega,D4./M4+notu,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Id,a.Id,Wbu.*xf.*(ra+r)./xeq-notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Iq,a.Iq,Wbu.*(ra+r)./(xq+xl)+notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.If,a.If,Wbu.*(xd+xl).*rf./xeq-notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Edc,a.Edc,notu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Eqc,a.Eqc,notu,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.delta_HP,a.omega_HP,Wbu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.delta_IP,a.omega_IP,Wbu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.delta_LP,a.omega_LP,Wbu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.delta,a.omega,Wbu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.delta_EX,a.omega_EX,Wbu,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_HP,a.delta_HP,k12./M1,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_HP,a.delta_IP,k12./M1,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_IP,a.delta_HP,k12./M2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_IP,a.delta_IP,(k12+k23)./M2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_IP,a.delta_LP,k23./M2,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_LP,a.delta_IP,k23./M3,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_LP,a.delta_LP,(k23+k34)./M3,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_LP,a.delta,k34./M3,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega_EX,a.delta,k45./M5,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega_EX,a.delta_EX,k45./M5,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega,a.delta_LP,k34./M4,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega,a.delta,(k34+k45)./M4,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.omega,a.delta_EX,k45./M4,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega,a.Id,a.u.*(xq-xd).*iq./M4,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega,a.Iq,a.u.*((xq-xd).*id+xad.*If)./M4,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.omega,a.If,a.u.*xad.*iq./M4,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Edc,a.Id,Wbu.*xc,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Edc,a.Eqc,Wbu,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Eqc,a.Iq,Wbu.*xc,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Eqc,a.Edc,Wbu,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Id,a.Iq,Wbu.*xf.*(xl+w.*xq)./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Id,a.If,Wbu.*xad.*rf./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Id,a.Edc,Wbu.*xf./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Id,a.omega,Wbu.*xf.*iq.*xq./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Id,a.delta,Wbu.*V.*xf.*cdt./xeq,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.If,a.Id,Wbu.*xad.*(ra+r)./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.If,a.Iq,Wbu.*xad.*(xl+w.*xq)./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.If,a.Edc,Wbu.*xad./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.If,a.omega,Wbu.*xad.*iq.*xq./xeq,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.If,a.delta,Wbu.*xad.*V.*cdt./xeq,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Iq,a.Id,Wbu.*(xl+w.*xd)./(xq+xl),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Iq,a.If,Wbu.*(w.*xad)./(xq+xl),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.Iq,a.Eqc,Wbu./(xq+xl),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Iq,a.omega,Wbu.*(If.*xad-xd.*id)./(xq+xl),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Iq,a.delta,Wbu.*V.*sdt./(xq+xl),psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.Id,a.bus,Wbu.*V.*cdt.*xf./xeq,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.Id,a.vbus,Wbu.*sdt.*xf./xeq,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.If,a.bus,Wbu.*V.*cdt.*xad./xeq,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.If,a.vbus,Wbu.*sdt.*xad./xeq,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.Iq,a.bus,Wbu.*V.*sdt./(xq+xl),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.Iq,a.vbus,Wbu.*cdt./(xq+xl),psat_obj.DAE.n,psat_obj.DAE.m);

psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.Id,V.*sdt,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.Id,V.*cdt,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.Iq,V.*cdt,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vbus,a.Iq,V.*sdt,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.bus,a.delta,-V.*cdt.*id+V.*sdt.*iq,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vbus,a.delta,V.*sdt.*id+V.*cdt.*iq,psat_obj.DAE.m,psat_obj.DAE.n);
