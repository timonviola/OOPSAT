function a = dynidx(a,psat_obj)


if ~a.n, return, end

a.xp = zeros(a.n,1);
a.xq = zeros(a.n,1);
for i = 1:a.n
  a.xp(i) = psat_obj.DAE.n + 1;
  a.xq(i) = psat_obj.DAE.n + 2;
  psat_obj.DAE.n = psat_obj.DAE.n + 2;
end
