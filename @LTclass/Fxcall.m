function Fxcall(p,psat_obj)

if ~p.n, return, end

mc = psat_obj.DAE.x(p.mc);
md = psat_obj.DAE.y(p.md);

h = p.con(:,7);
k = p.con(:,8);
mmax = p.con(:,9);
mmin = p.con(:,10);

u = mc < mmax & mc > mmin & p.u;

psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.md, p.mc, p.u, psat_obj.DAE.m, psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.mc, p.mc, h+(~u), psat_obj.DAE.n, psat_obj.DAE.n);

% voltage control
u1 = u.*(p.con(:,16) == 1 | p.con(:,16) == 3);
if sum(u1)
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.mc, p.vr, u1.*k, psat_obj.DAE.n, psat_obj.DAE.m);
end

% reactive power control
u2 = u.*(p.con(:,16) == 2);
if sum(u2)

  V1 = u.*psat_obj.DAE.y(p.v1);
  V2 = u.*psat_obj.DAE.y(p.v2);
  V12 = V1.*V2;
  y = admittance(p);
  g = real(y);
  b = imag(y);
  [s12,c12] = angles(p);
  k2 = c12.*g - s12.*b;
  k4 = s12.*g + c12.*b;
  ku = u2.*k./md;
  a1 = -ku.*(V2.*k4);
  a2 = -ku.*(-2*md.*V2.*b+V1.*k4);
  a3 = -ku.*(V12.*k2);
  w = ~p.con(:,11);
  
  psat_obj.DAE.Fy = psat_obj.DAE.Fy ... 
           + sparse(p.mc, p.md, w.*ku.*V12.*k4./md, psat_obj.DAE.n, psat_obj.DAE.m) ...
           + sparse(p.mc, p.v1, a1, psat_obj.DAE.n, psat_obj.DAE.m) ...
           + sparse(p.mc, p.v2, a2, psat_obj.DAE.n, psat_obj.DAE.m) ...
           + sparse(p.mc, p.bus1, a3, psat_obj.DAE.n, psat_obj.DAE.m) ...
           - sparse(p.mc, p.bus2, a3, psat_obj.DAE.n, psat_obj.DAE.m);
end
