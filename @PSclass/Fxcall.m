function Fxcall(a,psat_obj)

if ~a.n, return, end

type = a.con(:,2);
ty1 = find(type == 1);
ty2 = find(type == 2 | type == 4);
ty3 = find(type == 3 | type == 5);
tya = find(type > 1);
tyb = find(type > 3);

SIw = find(a.con(:,3) == 1);
SIp = find(a.con(:,3) == 2);
SIv = find(a.con(:,3) == 3);

Tw = a.con(:,7);
T1 = a.con(:,8);
T2 = a.con(:,9);
T3 = a.con(:,10);
T4 = a.con(:,11);
Ta = a.con(:,13);

Kw = a.con(:,6);
Ka = a.con(:,12);
Kp = a.con(:,14);
Kv = a.con(:,15);

vsmax = a.con(:,4);
vsmin = a.con(:,5);
vamax = a.con(:,16);
vathr = a.con(:,17);

S2 = a.con(:,22);
S2 = (((psat_obj.DAE.x(a.omega)-1) < 0) | S2) & S2 >= 0;

vss = psat_obj.DAE.y(a.vss);
z = vss < vsmax & vss > vsmin & a.u;

% common Jacobians elements

psat_obj.DAE.Fx = psat_obj.DAE.Fx ...
         - sparse(a.v1,a.v1,1./Tw,psat_obj.DAE.n,psat_obj.DAE.n) ...
         - sparse(a.v1,a.omega,a.u.*Kw./Tw,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fy = psat_obj.DAE.Fy ...
         - sparse(a.v1,a.vbus,a.u.*Kv./Tw,psat_obj.DAE.n,psat_obj.DAE.m) ...
         - sparse(a.v1,a.p,a.u.*Kp./Tw,psat_obj.DAE.n,psat_obj.DAE.m);

if ty1
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty1),a.omega(ty1),z(ty1).*Kw(ty1),psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty1),a.v1(ty1),z(ty1),psat_obj.DAE.m,psat_obj.DAE.n);
end

if ty2

  A = T1(ty2)./T2(ty2);
  B = 1-A;
  C = T3(ty2)./T4(ty2);
  D = 1-C;
  E = C.*A;
  F = a.u(ty2).*D./T4(ty2);
  G = a.u(ty2).*B./T2(ty2);

  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v2(ty2),a.v1(ty2),G,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.v2(ty2),a.v2(ty2),1./T2(ty2),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v2(ty2),a.omega(ty2),G.*Kw(ty2),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.v2(ty2),a.vbus(ty2),G.*Kv(ty2),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.v2(ty2),a.p(ty2),G.*Kp(ty2),psat_obj.DAE.n,psat_obj.DAE.m);

  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v3(ty2),a.v1(ty2),F.*A,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v3(ty2),a.v2(ty2),F,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.v3(ty2),a.v3(ty2),1./T4(ty2),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v3(ty2),a.omega(ty2),F.*A.*Kw(ty2),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.v3(ty2),a.vbus(ty2),F.*A.*Kv(ty2),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.v3(ty2),a.p(ty2),F.*A.*Kp(ty2),psat_obj.DAE.n,psat_obj.DAE.m);

  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty2),a.v3(ty2),z(ty2),psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty2),a.v2(ty2),z(ty2).*C,psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty2),a.v1(ty2),z(ty2).*E,psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty2),a.omega(ty2),z(ty2).*Kw(ty2).*E,psat_obj.DAE.m,psat_obj.DAE.n);

end

if ty3

  iT2 = 1./T2(ty3);
  A = T1(ty3).*iT2;
  B = 1-A;
  C = T3(ty3) - A.*T4(ty3);
 
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v2(ty3),a.v3(ty3),a.u(ty3),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.v3(ty3),a.v2(ty3),a.u(ty3).*iT2,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.v3(ty3),a.v3(ty3),T4(ty3).*iT2,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v3(ty3),a.v1(ty3),z(ty3).*iT2,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.v3(ty3),a.omega(ty3),z(ty3).*Kw(ty3).*iT2,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.v3(ty3),a.vbus(ty3),z(ty3).*Kv(ty3).*iT2,psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.v3(ty3),a.p(ty3),z(ty3).*Kp(ty3).*iT2,psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty3),a.v3(ty3),z(ty3).*C,psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty3),a.v2(ty3),z(ty3).*B,psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty3),a.v1(ty3),z(ty3).*A,psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(ty3),a.omega(ty3),z(ty3).*Kw(ty3).*A,psat_obj.DAE.m,psat_obj.DAE.n);
  
end

if tyb

  Kw(SIw) = a.con(SIw,12);
  Kp(SIp) = a.con(SIp,12);
  Kv(SIv) = a.con(SIv,12);
  va = min(S2(tyb).*psat_obj.DAE.x(a.va(tyb)),vathr(tyb));
  zb = z(tyb) & va < vamax(tyb) & va < vathr(tyb) & va > 0;
  s1 = a.s1(tyb) & a.u(tyb)
  
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.va(tyb),a.va(tyb),s1./Ta(tyb),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.va(tyb),a.va(tyb),1 - a.u(tyb),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.va(tyb),a.omega(tyb),s1.*Kw(tyb)./Ta(tyb),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vss(tyb),a.va(tyb),zb,psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.va(tyb),a.vbus(tyb),s1.*Kv(tyb)./Ta(tyb),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.va(tyb),a.p(tyb),s1.*Kp(tyb)./Ta(tyb),psat_obj.DAE.n,psat_obj.DAE.m);

end
