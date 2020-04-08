function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.vp = zeros(a.n,1);
a.vq = zeros(a.n,1);
a.iq = zeros(a.n,1);
a.vp0 = zeros(a.n,1);
a.vq0 = zeros(a.n,1);
a.vref = zeros(a.n,1);

for i = 1:a.n
  a.vp(i) = psat_obj.DAE.n + 1;
  a.vq(i) = psat_obj.DAE.n + 2;     
  a.iq(i) = psat_obj.DAE.n + 3;
  psat_obj.DAE.n = psat_obj.DAE.n + 3;
  a.vp0(i) = psat_obj.DAE.m + 1;
  a.vq0(i) = psat_obj.DAE.m + 2;     
  a.vref(i) = psat_obj.DAE.m + 3;
  psat_obj.DAE.m = psat_obj.DAE.m + 3;
end

a.gamma = zeros(a.n,1);
