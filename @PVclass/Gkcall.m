function Gkcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.Gk(p.bus) = psat_obj.DAE.Gk(p.bus) - p.u.*p.con(:,10).*p.con(:,4);
