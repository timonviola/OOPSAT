function a = dynidx(a,psat_obj)
if ~a.n, return, end

a.x = zeros(a.n,1);
a.w = zeros(a.n,1);
for i = 1:a.n
  a.x(i) = psat_obj.DAE.n + 1;
  a.w(i) = psat_obj.DAE.n + 2;
  psat_obj.DAE.n = psat_obj.DAE.n + 2;
end
