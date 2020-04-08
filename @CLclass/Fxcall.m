function Fxcall(p,psat_obj)

if ~p.n, return, end

Vs = psat_obj.DAE.x(p.Vs);
u = p.u & Vs < p.con(:,8) & Vs > p.con(:,9);

psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.vref,p.Vs,u,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.Vs,p.Vs,~u,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.Vs,p.cac,u.*p.con(:,7).*p.dVsdQ,psat_obj.DAE.n,psat_obj.DAE.m) ...
         - sparse(p.Vs,p.q,u.*p.dVsdQ,psat_obj.DAE.n,psat_obj.DAE.m);
