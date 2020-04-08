function glambda(p,lambda,kg,psat_obj)


if ~p.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g - sparse(p.bus,1,(lambda+kg*p.con(:,15)).*p.u.*p.con(:,3),psat_obj.DAE.m,1);
