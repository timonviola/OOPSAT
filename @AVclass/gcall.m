function gcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g + sparse(p.vfd,1,psat_obj.DAE.x(p.vf),psat_obj.DAE.m,1);
psat_obj.DAE.g = psat_obj.DAE.g + sparse(p.vref,1,p.u.*p.vref0-psat_obj.DAE.y(p.vref),psat_obj.DAE.m,1);
