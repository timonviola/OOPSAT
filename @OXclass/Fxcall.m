function Fxcall(p,psat_obj)
if ~p.n, return, end

z = psat_obj.DAE.x(p.v) > 0 & psat_obj.DAE.x(p.v) < p.con(:,7) & p.u;

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(p.v,p.v,-1e-6,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v,p.If,z./p.con(:,2),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.vref,p.v,z,psat_obj.DAE.m,psat_obj.DAE.n);
