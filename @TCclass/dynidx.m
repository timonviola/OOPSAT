function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.x1 = zeros(a.n,1);
a.x2 = zeros(a.n,1);
a.x0 = zeros(a.n,1);
a.pref = zeros(a.n,1);

for i = 1:a.n
  a.x1(i) = psat_obj.DAE.n + 1;
  if a.con(i,3) == 2
    a.x2(i) = psat_obj.DAE.n + 2;
    psat_obj.DAE.n = psat_obj.DAE.n + 2;
  else
    psat_obj.DAE.n = psat_obj.DAE.n + 1;
  end
  a.x0(i) = psat_obj.DAE.m + 1;
  a.pref(i) = psat_obj.DAE.m + 2;
  psat_obj.DAE.m = psat_obj.DAE.m + 2;
end
