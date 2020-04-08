function glambda(p,lambda,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g(p.bus) = lambda*p.con(:,4).*p.u + psat_obj.DAE.g(p.bus);
psat_obj.DAE.g(p.vbus) = lambda*p.con(:,5).*p.u + psat_obj.DAE.g(p.vbus);
