function glambda(p,lambda,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g + sparse(p.bus,1,lambda*p.u.*p.con(:,3),psat_obj.DAE.m,1) ...
        + sparse(p.vbus,1,lambda*p.u.*p.con(:,4),psat_obj.DAE.m,1);
