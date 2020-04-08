function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.T = psat_obj.DAE.n + [1:2:2*a.n]';
a.x = psat_obj.DAE.n + [2:2:2*a.n]';
psat_obj.DAE.n = psat_obj.DAE.n + 2*a.n;

a.G = psat_obj.DAE.m + [1:a.n]';
psat_obj.DAE.m = psat_obj.DAE.m + a.n;