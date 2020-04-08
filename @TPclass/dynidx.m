function a = dynidx(a,psat_obj)
if ~a.n, return, end

a.m = psat_obj.DAE.n + [1:a.n]';
psat_obj.DAE.n = psat_obj.DAE.n + a.n;
