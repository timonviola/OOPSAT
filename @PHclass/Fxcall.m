function Fxcall(p,psat_obj)

if ~p.n, return, end

alpha = psat_obj.DAE.x(p.alpha);
V1 = p.u.*psat_obj.DAE.y(p.v1);
V2 = p.u.*psat_obj.DAE.y(p.v2);

Tm = p.con(:,7);
Kp = p.con(:,8);
Ki = p.con(:,9);
Pref = p.con(:,10);

a_max = p.con(:,13);
a_min = p.con(:,14);

V12 = V1.*V2;
y = admittance(p);
g = real(y);
b = imag(y);
m = p.con(:,15);

[s12,c12] = angles(p);

k1 = (c12.*g+s12.*b)./m;
k2 = (c12.*g-s12.*b)./m;
k3 = (s12.*g-c12.*b)./m;
k4 = (s12.*g+c12.*b)./m;

b1 = 2.*V1.*g./m./m-V2.*k1;
b2 = V1.*k1;

k1 = V12.*k1;
k2 = V12.*k2;
k3 = V12.*k3;
k4 = V12.*k4;

idx = find(alpha < a_max & alpha > a_min & p.u);
if ~isempty(idx)
  
  ai  = p.alpha(idx);
  b1i = p.bus1(idx);
  b2i = p.bus2(idx);
  v1i = p.v1(idx);
  v2i = p.v2(idx);
  pmi = p.Pm(idx);
  
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(ai,pmi,Kp(idx)./Tm(idx)-Ki(idx),psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(pmi,ai,k3(idx)./Tm(idx),psat_obj.DAE.n,psat_obj.DAE.n);
  
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(ai,v1i,Kp(idx).*b1(idx)./Tm(idx),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(ai,v2i,Kp(idx).*b2(idx)./Tm(idx),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(ai,b1i,Kp(idx).*k3(idx)./Tm(idx),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(ai,b2i,Kp(idx).*k3(idx)./Tm(idx),psat_obj.DAE.n,psat_obj.DAE.m);
  
  psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(b1i,ai,k3(idx),psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(v1i,ai,k1(idx),psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(b2i,ai,k4(idx),psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(v2i,ai,k2(idx),psat_obj.DAE.m,psat_obj.DAE.n);
  
end

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.alpha,p.alpha,(Kp.*k3+(~p.u))./Tm,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.Pm,p.Pm,1./Tm,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.Pm,p.v1,b1./Tm,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(p.Pm,p.v2,b2./Tm,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.Pm,p.bus1,k3./Tm,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(p.Pm,p.bus2,k3./Tm,psat_obj.DAE.n,psat_obj.DAE.m);
