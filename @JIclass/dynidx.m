function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.x = psat_obj.DAE.n + [1:a.n]';
psat_obj.DAE.n = psat_obj.DAE.n + a.n;
