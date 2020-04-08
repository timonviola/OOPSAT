function xfirst(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.x(a.mc) = ones(a.n,1);
psat_obj.DAE.y(a.md) = ones(a.n,1);
