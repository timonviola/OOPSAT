function Fxcall(p,psat_obj)

if ~p.n, return, end

m = psat_obj.DAE.x(p.m);
V = psat_obj.DAE.y(p.vbus);
h = p.con(:,4);

u = m < p.con(:,6) & m > p.con(:,7) & p.u;

k = u.*p.con(:,5);
a = u.*p.con(:,11);
b = u.*p.con(:,12);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.m,p.m,h+V.*k./m./m,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.m,p.vbus,k./m,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.bus,p.m,p.con(:,9).*a.*(V.^a)./(m.^(a+1)),psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.vbus,p.m,p.con(:,10).*b.*(V.^b)./(m.^(b+1)),psat_obj.DAE.m,psat_obj.DAE.n);
