function a = Gycall(a,psat_obj)

if ~a.n, return, end

delta = psat_obj.DAE.x(a.delta);
ag = psat_obj.DAE.y(a.bus);
vg = a.u.*psat_obj.DAE.y(a.vbus);
ss = sin(delta-ag);
cc = cos(delta-ag);

M1 = vg.*(a.c1.*cc-a.c3.*ss);
M2 = -vg.*(a.c2.*cc+a.c1.*ss);
M3 = -(a.c1.*ss+a.c3.*cc);
M4 = a.c2.*ss-a.c1.*cc;

a.J11 = vg.*((a.Id-M2).*cc-(M1+a.Iq).*ss);
a.J12 = -a.Id.*ss-a.Iq.*cc-vg.*(M3.*ss+M4.*cc);
a.J21 = vg.*((M2-a.Id).*ss-(M1+a.Iq).*cc);
a.J22 = -a.Id.*cc+a.Iq.*ss-vg.*(M3.*cc-M4.*ss);

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.bus,a.p,a.u,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vbus,a.q,a.u,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.p,a.p,1,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.q,a.q,1,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.p,a.bus, a.J11,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.p,a.vbus,a.J12,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.q,a.bus, a.J21,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.q,a.vbus,a.J22,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.pm,a.pm,1,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vf,a.vf,1,psat_obj.DAE.m,psat_obj.DAE.m);

is2  = find(a.con(:,5) == 2);
if ~isempty(is2)
  Kp = a.con(is2,21);
  q1 = vg(is2).*(ss(is2).*a.c3(is2)+cc(is2).*a.c1(is2));
  q2 = vg(is2).*(cc(is2).*a.c3(is2)-ss(is2).*a.c1(is2));
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.p(is2),a.vf(is2),q1,psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.q(is2),a.vf(is2),q2,psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.p(is2),a.p(is2),Kp.*q1,psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.q(is2),a.p(is2),Kp.*q2,psat_obj.DAE.m,psat_obj.DAE.m);
end
