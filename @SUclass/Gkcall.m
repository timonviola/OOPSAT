function Gkcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.Gk = psat_obj.DAE.Gk - sparse(p.bus,1,p.u.*p.con(:,15).*p.con(:,3),psat_obj.DAE.m,1);
