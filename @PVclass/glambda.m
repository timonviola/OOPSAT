function glambda(p,lambda,kg,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g(p.bus) = psat_obj.DAE.g(p.bus) - p.u.*(lambda+kg*p.con(:,10)).*p.con(:,4);
