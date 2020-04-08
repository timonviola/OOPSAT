function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.id = zeros(a.n,1);
a.iq = zeros(a.n,1);
for i = 1:a.n
  a.id(i) = psat_obj.DAE.n + 1;
  a.iq(i) = psat_obj.DAE.n + 2;
  psat_obj.DAE.n = psat_obj.DAE.n + 2;
end
