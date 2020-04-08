function gcall(p,psat_obj)
% computes algebraic equations g

if ~p.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g ...
    + sparse(p.pm,1,p.u.*pmech(p,psat_obj),psat_obj.DAE.m,1) ...
    + sparse(p.wref,1,p.u.*p.con(:,3)-psat_obj.DAE.y(p.wref),psat_obj.DAE.m,1);
