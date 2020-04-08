function a = setx0(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
theta = psat_obj.DAE.y(a.bus);

xd  = a.con(:,5);
xq  = a.con(:,6);
ra  = a.con(:,7);
xad = a.con(:,8);
r   = a.con(:,9);
xl  = a.con(:,10);
xc  = a.con(:,11);
rf  = a.con(:,12);
xf  = a.con(:,13);
k12 = a.con(:,24);
k23 = a.con(:,25);
k34 = a.con(:,26);
k45 = a.con(:,27);

VV =  V.*exp(i*theta);
S = psat_obj.Bus.Pg(a.bus) - i*psat_obj.Bus.Qg(a.bus);
Ig = S./conj(VV);
delta = angle(VV + (ra+r + i*(xq+xl-xc)).*Ig);
cdt = cos(delta-theta);
sdt = sin(delta-theta);
Idq = Ig.*exp(-i*(delta-pi/2));
Id = real(Idq);
Iq = imag(Idq);
If = (xl.*Id+(ra+r).*Iq+xd.*Id-xc.*Id+V.*cdt)./xad;
Te = (xq-xd).*Id.*Iq+xad.*If.*Iq;
delta_LP = Te./k34+delta;
delta_IP = ((k23+k34).*delta_LP-k34.*delta)./k23;
delta_HP = ((k12+k23).*delta_IP-k23.*delta_LP)./k12;
B = (ra+r).*Id-xl.*Iq-xq.*Iq+xc.*Iq+V.*sdt;

a.Tm = k12.*delta_HP-k12.*delta_IP;
a.Efd = xf.*B./rf + xad.*If;

psat_obj.DAE.x(a.Id) = a.u.*Id;
psat_obj.DAE.x(a.Iq) = a.u.*Iq;
psat_obj.DAE.x(a.If) = a.u.*If;

psat_obj.DAE.x(a.omega_HP) = a.u;
psat_obj.DAE.x(a.omega_IP) = a.u;
psat_obj.DAE.x(a.omega_LP) = a.u;
psat_obj.DAE.x(a.omega) = a.u;
psat_obj.DAE.x(a.omega_EX) = a.u;

psat_obj.DAE.x(a.Eqc) = -a.u.*xc.*Id;
psat_obj.DAE.x(a.Edc) =  a.u.*xc.*Iq;

psat_obj.DAE.x(a.delta) = a.u.*delta;
psat_obj.DAE.x(a.delta_EX) = a.u.*delta;
psat_obj.DAE.x(a.delta_HP) = a.u.*delta_HP;
psat_obj.DAE.x(a.delta_IP) = a.u.*delta_IP;
psat_obj.DAE.x(a.delta_LP) = a.u.*delta_LP;

% find & delete static generators
check = 1;
for j = 1:a.n
  if ~fm_rmgen(a.u(j)*a.bus(j)), check = 0; end
end

if ~check
  psat_obj.fm_disp('SSR models cannot be properly initialized.')
else
  psat_obj.fm_disp('Initialization of SSR models completed.')
end
