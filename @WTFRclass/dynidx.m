function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.Dfm = zeros(a.n,1);
a.x = zeros(a.n,1);
a.csi = zeros(a.n,1);
a.pfw = zeros(a.n,1);
a.pf1 = zeros(a.n, 1);
a.pwa = zeros(a.n, 1);

for i = 1:a.n
  a.Dfm(i) = psat_obj.DAE.n + 1;
  a.x(i) = psat_obj.DAE.n + 2;
  a.csi(i) = psat_obj.DAE.n + 3;
  a.pfw(i) = psat_obj.DAE.n + 4;
  psat_obj.DAE.n = psat_obj.DAE.n + 4;
  a.pf1(i) = psat_obj.DAE.m + 1;
  a.pwa(i) = psat_obj.DAE.m + 2;
  psat_obj.DAE.m = psat_obj.DAE.m + 2;
end

a.pout = psat_obj.Dfig.pwa(a.gen);
a.we = psat_obj.Dfig.omega_m(a.gen);
a.Df = psat_obj.Busfreq.w(a.freq);
