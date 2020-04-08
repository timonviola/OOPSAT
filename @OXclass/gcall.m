function gcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g - sparse(psat_obj.Exc.vref(p.exc),1,psat_obj.DAE.x(p.v),psat_obj.DAE.m,1);
psat_obj.DAE.g = psat_obj.DAE.g + sparse(p.If,1,ifield(p,1)-psat_obj.DAE.y(p.If),psat_obj.DAE.m,1);

