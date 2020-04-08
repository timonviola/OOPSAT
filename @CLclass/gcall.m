function gcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g + sparse(p.vref,1,p.u.*psat_obj.DAE.x(p.Vs),psat_obj.DAE.m,1);
