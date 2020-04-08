function a = dynidx(a,psat_obj)
if ~a.n, return, end

for i = 1:a.n
  a.alpha(i) = psat_obj.DAE.n + 1;
  a.Pm(i) = psat_obj.DAE.n + 2;
  psat_obj.DAE.n = psat_obj.DAE.n + 2;
end
