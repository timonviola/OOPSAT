function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.omega_t = zeros(a.n,1);
a.omega_m = zeros(a.n,1);
a.gamma = zeros(a.n,1);
a.e1r = zeros(a.n,1);
a.e1m = zeros(a.n,1);
for i = 1:a.n
  a.omega_t(i) = psat_obj.DAE.n + 1;
  a.omega_m(i) = psat_obj.DAE.n + 2;
  a.gamma(i) = psat_obj.DAE.n + 3;
  a.e1r(i) = psat_obj.DAE.n + 4;
  a.e1m(i) = psat_obj.DAE.n + 5;
  psat_obj.DAE.n = psat_obj.DAE.n + 5;
end
