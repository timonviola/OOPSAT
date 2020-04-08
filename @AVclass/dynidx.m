function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.vm  = zeros(a.n,1);
a.vr1 = zeros(a.n,1);
a.vr2 = zeros(a.n,1);
a.vr3 = zeros(a.n,1);
a.vf = zeros(a.n,1);
a.vfd = psat_obj.Syn.vf(a.syn);

a.vref0 = ones(a.n,1);
a.vref  = psat_obj.DAE.m + [1:a.n]';
psat_obj.DAE.m = psat_obj.DAE.m + a.n;

for i = 1:a.n
  switch a.con(i,2)
   case 1
    a.vm(i)  = psat_obj.DAE.n + 1;
    a.vr1(i) = psat_obj.DAE.n + 2;
    a.vr2(i) = psat_obj.DAE.n + 3;
    a.vf(i) = psat_obj.DAE.n + 4;
    psat_obj.DAE.n = psat_obj.DAE.n + 4;
   case 2
    a.vm(i)  = psat_obj.DAE.n + 1;
    a.vr1(i) = psat_obj.DAE.n + 2;
    a.vr2(i) = psat_obj.DAE.n + 3;
    a.vf(i) = psat_obj.DAE.n + 4;
    psat_obj.DAE.n = psat_obj.DAE.n + 4;
   case 3
    a.vm(i)  = psat_obj.DAE.n + 1;
    a.vr3(i) = psat_obj.DAE.n + 2;
    a.vf(i) = psat_obj.DAE.n + 3;
    psat_obj.DAE.n = psat_obj.DAE.n + 3;
  end
end
