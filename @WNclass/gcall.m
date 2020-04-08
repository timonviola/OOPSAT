function gcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.g(a.ws) = psat_obj.DAE.lambda*wspeed(a)-psat_obj.DAE.y(a.ws);
