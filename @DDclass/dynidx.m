function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.theta_p = zeros(a.n,1);
a.omega_m = zeros(a.n,1);
a.iqs = zeros(a.n,1);
a.ids = zeros(a.n,1);
a.iqc = zeros(a.n,1);
a.pwa = zeros(a.n,1);
for i = 1:a.n
  a.omega_m(i) = psat_obj.DAE.n + 1;
  a.theta_p(i) = psat_obj.DAE.n + 2;
  a.iqs(i) = psat_obj.DAE.n + 3;
  a.idc(i) = psat_obj.DAE.n + 4;
  psat_obj.DAE.n = psat_obj.DAE.n + 4;
  a.ids(i) = psat_obj.DAE.m + 1;
  a.iqc(i) = psat_obj.DAE.m + 2;
  a.pwa(i) = psat_obj.DAE.m + 3; 
  psat_obj.DAE.m = psat_obj.DAE.m + 3;
end
