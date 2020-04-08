function a = dynidx(a,psat_obj)


if ~a.n, return, end

a.vm = zeros(a.n,1);
a.thetam = zeros(a.n,1);
for i = 1:a.n
  a.vm(i) = psat_obj.DAE.n + 1;
  a.thetam(i) = psat_obj.DAE.n + 2;
  psat_obj.DAE.n = psat_obj.DAE.n + 2;
end
