function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.theta_p = zeros(a.n,1);
a.omega_m = zeros(a.n,1);
a.idr = zeros(a.n,1);
a.iqr = zeros(a.n,1);
a.vref = zeros(a.n,1);
a.pwa = zeros(a.n,1);
for i = 1:a.n
  a.omega_m(i) = psat_obj.DAE.n + 1;
  a.theta_p(i) = psat_obj.DAE.n + 2;
  a.idr(i) = psat_obj.DAE.n + 3;
  a.iqr(i) = psat_obj.DAE.n + 4;
  psat_obj.DAE.n = psat_obj.DAE.n + 4;
  a.pwa(i) = psat_obj.DAE.m + 1;
  a.vref(i) = psat_obj.DAE.m + 2;
  psat_obj.DAE.m = psat_obj.DAE.m + 2;
end
