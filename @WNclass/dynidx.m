function a = dynidx(a,psat_obj)


if ~a.n, return, end

a.vw = psat_obj.DAE.n + [1:a.n]';
psat_obj.DAE.n = psat_obj.DAE.n + a.n;
a.ws = psat_obj.DAE.m + [1:a.n]';
psat_obj.DAE.m = psat_obj.DAE.m + a.n;
