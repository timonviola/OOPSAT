function glambda(a,lambda,kg,psat_obj)

if ~a.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.pm,1,(1-lambda-kg)*a.pm0.*a.u,psat_obj.DAE.m,1);

