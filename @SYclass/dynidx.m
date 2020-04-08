function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.delta = zeros(a.n,1);
a.omega = zeros(a.n,1);
a.e1q = zeros(a.n,1);
a.e1d = zeros(a.n,1);
a.e2q = zeros(a.n,1);
a.e2d = zeros(a.n,1);
a.psiq = zeros(a.n,1);
a.psid = zeros(a.n,1);
a.pm = zeros(a.n,1);
a.vf = zeros(a.n,1);
a.p = zeros(a.n,1);
a.q = zeros(a.n,1);

for i = 1:a.n
  a.delta(i) = psat_obj.DAE.n + 1;
  a.omega(i) = psat_obj.DAE.n + 2;
  a.vf(i) = psat_obj.DAE.m + 1;
  a.pm(i) = psat_obj.DAE.m + 2;
  a.p(i) = psat_obj.DAE.m + 3;
  a.q(i) = psat_obj.DAE.m + 4;
  psat_obj.DAE.m = psat_obj.DAE.m + 4;
  syn_ord = a.con(i,5);
  switch syn_ord
   case 2
    psat_obj.DAE.n = psat_obj.DAE.n+2;
   case 3
    a.e1q(i) =   psat_obj.DAE.n + 3;
    psat_obj.DAE.n = psat_obj.DAE.n+3;
   case 4
    a.e1q(i) =   psat_obj.DAE.n + 3;
    a.e1d(i) =   psat_obj.DAE.n + 4;
    psat_obj.DAE.n = psat_obj.DAE.n+4;
   case 5
    a.con(i,5) = 5.1;
    a.e1q(i) =   psat_obj.DAE.n + 3;
    a.e1d(i) =   psat_obj.DAE.n + 4;
    a.e2d(i) =   psat_obj.DAE.n + 5;
    psat_obj.DAE.n = psat_obj.DAE.n+5;
   case 5.1
    a.e1q(i) =   psat_obj.DAE.n + 3;
    a.e1d(i) =   psat_obj.DAE.n + 4;
    a.e2d(i) =   psat_obj.DAE.n + 5;
    psat_obj.DAE.n = psat_obj.DAE.n+5;
   case 5.2
    a.e1q(i) =   psat_obj.DAE.n + 3;
    a.e2q(i) =   psat_obj.DAE.n + 4;
    a.e2d(i) =   psat_obj.DAE.n + 5;
    psat_obj.DAE.n = psat_obj.DAE.n+5;
   case 5.3
    a.e1q(i) =   psat_obj.DAE.n + 3;
    a.psid(i) =   psat_obj.DAE.n + 4;
    a.psiq(i) =   psat_obj.DAE.n + 5;
    psat_obj.DAE.n = psat_obj.DAE.n+5;
   case 6
    a.e1q(i) =   psat_obj.DAE.n + 3;
    a.e1d(i) =   psat_obj.DAE.n + 4;
    a.e2q(i) =   psat_obj.DAE.n + 5;
    a.e2d(i) =   psat_obj.DAE.n + 6;
    psat_obj.DAE.n = psat_obj.DAE.n+6;
   case 8
    a.e1q(i)   = psat_obj.DAE.n + 3;
    a.e1d(i)   = psat_obj.DAE.n + 4;
    a.e2q(i)   = psat_obj.DAE.n + 5;
    a.e2d(i)   = psat_obj.DAE.n + 6;
    a.psiq(i)  = psat_obj.DAE.n + 7;
    a.psid(i)  = psat_obj.DAE.n + 8;
    psat_obj.DAE.n = psat_obj.DAE.n+8;
  end
end
