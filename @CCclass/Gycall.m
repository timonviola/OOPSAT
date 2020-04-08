function Gycall(p,psat_obj)

if ~p.n, return, end

KP = p.u.*p.con(:,7);

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(p.q,p.q,1,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(p.q,p.vbus,KP,psat_obj.DAE.m,psat_obj.DAE.m);
