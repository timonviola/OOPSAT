function Fxcall(p,psat_obj)

if ~p.n, return, end

q1 = psat_obj.DAE.x(p.q1);
KI = p.con(:,6);

u = p.u & q1 < p.con(:,8) & q1 > p.con(:,9);

psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.q,p.q1,u,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.q1,p.q1,~u,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.q1,p.vbus,-KI.*u,psat_obj.DAE.n,psat_obj.DAE.m);
