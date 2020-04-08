function a = dynidx(a,psat_obj)
% assigns indexes to the state variables

if ~a.n, return, end

a.ty1 = find(a.con(:,2) == 1);
a.ty2 = find(a.con(:,2) == 2);
a.ty3 = find(a.con(:,2) == 3);
a.ty4 = find(a.con(:,2) == 4);
a.ty5 = find(a.con(:,2) == 5);
a.ty6 = find(a.con(:,2) == 6);
a.tg1 = zeros(a.n,1);
a.tg2 = zeros(a.n,1);
a.tg3 = zeros(a.n,1);
a.tg4 = zeros(a.n,1);
a.tg5 = zeros(a.n,1);
a.tg  = zeros(a.n,1);

for i = 1:a.n
  switch a.con(i,2)
   case 1
    a.tg1(i) = psat_obj.DAE.n + 1;
    a.tg2(i) = psat_obj.DAE.n + 2;
    a.tg3(i) = psat_obj.DAE.n + 3;
    psat_obj.DAE.n = psat_obj.DAE.n + 3;
   case 2
    a.tg(i) = psat_obj.DAE.n + 1;
    psat_obj.DAE.n = psat_obj.DAE.n + 1;
   case 3
    a.tg1(i) = psat_obj.DAE.n + 1;
    a.tg2(i) = psat_obj.DAE.n + 2;
    a.tg3(i) = psat_obj.DAE.n + 3;
    a.tg4(i) = psat_obj.DAE.n + 4;
    psat_obj.DAE.n = psat_obj.DAE.n + 4; 
   case 4
    a.tg1(i) = psat_obj.DAE.n + 1;
    a.tg2(i) = psat_obj.DAE.n + 2;
    a.tg3(i) = psat_obj.DAE.n + 3;
    a.tg4(i) = psat_obj.DAE.n + 4;
    a.tg5(i) = psat_obj.DAE.n + 5;
    psat_obj.DAE.n = psat_obj.DAE.n + 5;
   case 5
    a.tg1(i) = psat_obj.DAE.n + 1;
    a.tg2(i) = psat_obj.DAE.n + 2;
    a.tg3(i) = psat_obj.DAE.n + 3;
    a.tg4(i) = psat_obj.DAE.n + 4;
    psat_obj.DAE.n = psat_obj.DAE.n + 4; 
   case 6
    a.tg1(i) = psat_obj.DAE.n + 1;
    a.tg2(i) = psat_obj.DAE.n + 2;
    a.tg3(i) = psat_obj.DAE.n + 3;
    a.tg4(i) = psat_obj.DAE.n + 4;
    a.tg5(i) = psat_obj.DAE.n + 5;
    psat_obj.DAE.n = psat_obj.DAE.n + 5;
  end
end

a.wref = psat_obj.DAE.m + [1:a.n]';
psat_obj.DAE.m = psat_obj.DAE.m + a.n;

a.pm = psat_obj.Syn.pm(a.syn);
