function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.v1 = zeros(a.n,1);
a.v2 = zeros(a.n,1);
a.v3 = zeros(a.n,1);
a.va = zeros(a.n,1);

a.vss = psat_obj.DAE.m + [1:a.n]';
psat_obj.DAE.m = psat_obj.DAE.m + a.n;

for i = 1:a.n
  switch a.con(i,2)
   case 1
    a.v1(i) = psat_obj.DAE.n + 1;
    psat_obj.DAE.n = psat_obj.DAE.n + 1;
   case {2,3}
    a.v1(i) = psat_obj.DAE.n + 1;
    a.v2(i) = psat_obj.DAE.n + 2;
    a.v3(i) = psat_obj.DAE.n + 3;
    psat_obj.DAE.n = psat_obj.DAE.n + 3;
   case {4,5}
    a.v1(i) = psat_obj.DAE.n + 1;
    a.v2(i) = psat_obj.DAE.n + 2;
    a.v3(i) = psat_obj.DAE.n + 3;
    a.va(i) = psat_obj.DAE.n + 4;
    psat_obj.DAE.n = psat_obj.DAE.n + 4;
  end
end

a.s1 = zeros(a.n,1);
a.omega = psat_obj.Syn.omega(a.syn);
a.p = psat_obj.Syn.p(a.syn);
a.vf = psat_obj.Syn.vf(a.syn);
a.vref = psat_obj.Exc.vref(a.exc);
