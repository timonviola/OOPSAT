function gcall(p,psat_obj)
% Jacobian matrix Gy

if ~p.n, return, end

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(p.wref,p.wref,1,psat_obj.DAE.m,psat_obj.DAE.m);
