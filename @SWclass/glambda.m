function glambda(p,lambda,kg,psat_obj)
if ~p.n, return, end

jdx = find(p.u);
idx = p.bus(jdx);

if isempty(idx),return, end

psat_obj.DAE.g(idx) = psat_obj.DAE.g(idx) - (lambda+kg*p.con(jdx,11)).*p.pg(jdx);

