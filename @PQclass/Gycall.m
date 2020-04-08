function Gycall(p,psat_obj)

if ~p.n, return, end
if psat_obj.Settings.forcepq, return, end

vx = p.con(:,6);
vn = p.con(:,7);
z = p.con(:,8).*p.u;

a = find((psat_obj.DAE.y(p.vbus) < vn & z) | p.shunt);
b = find(psat_obj.DAE.y(p.vbus) > vx & z);
if ~isempty(a)
  h = p.bus(a);
  k = p.vbus(a);
  v2 = vn(a).*vn(a);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(h,k,2*p.con(a,4).*psat_obj.DAE.y(k)./v2,psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(k,k,2*p.con(a,5).*psat_obj.DAE.y(k)./v2,psat_obj.DAE.m,psat_obj.DAE.m);
end
if ~isempty(b)
  h = p.bus(b);
  k = p.vbus(b);
  v2 = vx(b).*vx(b);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(h,k,2*p.con(b,4).*psat_obj.DAE.y(k)./v2,psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(k,k,2*p.con(b,5).*psat_obj.DAE.y(k)./v2,psat_obj.DAE.m,psat_obj.DAE.m);
end

