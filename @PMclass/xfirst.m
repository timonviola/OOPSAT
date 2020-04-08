function xfirst(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.x(a.vm) = ones(a.n,1);
psat_obj.DAE.x(a.thetam) = zeros(a.n,1);
