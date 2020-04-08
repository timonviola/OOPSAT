function Fxcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
ist = psat_obj.DAE.x(a.ist);
Kr = a.con(:,5);
Tr = a.con(:,6);
ist_max = a.con(:,7);
ist_min = a.con(:,8);

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.ist,a.ist,a.u./Tr,psat_obj.DAE.n,psat_obj.DAE.n);     
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.ist,a.vref,a.u.*Kr./Tr,psat_obj.DAE.n,psat_obj.DAE.m);     

u = (ist <= ist_max & ist >= ist_min & a.u);

psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.ist,u.*V,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.ist,a.vbus,u.*Kr./Tr,psat_obj.DAE.n,psat_obj.DAE.m);
