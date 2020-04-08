function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.btx1 = zeros(a.n,1);
a.id = zeros(a.n,1);
a.iq = zeros(a.n,1);
a.vref = zeros(a.n,1);

for i = 1:a.n
  a.btx1(i) = psat_obj.DAE.n + 1;
  a.id(i) = psat_obj.DAE.n + 2;
  a.iq(i) = psat_obj.DAE.n + 3;
  psat_obj.DAE.n = psat_obj.DAE.n + 3;
  a.vref(i) = psat_obj.DAE.m + 1;
  psat_obj.DAE.m = psat_obj.DAE.m + 1;
end
