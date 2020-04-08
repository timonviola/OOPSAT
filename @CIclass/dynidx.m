function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.delta = zeros(a.n,1);
a.omega = zeros(a.n,1);

for i = 1:a.n
  a.delta(i) = psat_obj.DAE.m + 1;
  a.omega(i) = psat_obj.DAE.m + 2;
  psat_obj.DAE.m = psat_obj.DAE.m + 2;
end

a.dgen = psat_obj.Syn.delta(a.gen);
a.wgen = psat_obj.Syn.omega(a.gen);
