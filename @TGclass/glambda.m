function glambda(p,lambda,kg,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g - sparse(p.pm,1,(kg+lambda-1)*p.u.*pmech(p),psat_obj.DAE.m,1);
