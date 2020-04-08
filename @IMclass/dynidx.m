function a = dynidx(a,psat_obj)
if ~a.n, return, end

a.slip = zeros(a.n,1);
a.e1r = zeros(a.n,1);
a.e1m = zeros(a.n,1);
a.e2r = zeros(a.n,1);
a.e2m = zeros(a.n,1);

for i = 1:a.n
  mot_ord = a.con(i,5);
  switch mot_ord
   case 1
    a.slip(i) = psat_obj.DAE.n + 1;
    psat_obj.DAE.n = psat_obj.DAE.n+1;
   case 3
    a.slip(i) = psat_obj.DAE.n + 1;
    a.e1r(i) = psat_obj.DAE.n + 2;
    a.e1m(i) = psat_obj.DAE.n + 3;
    psat_obj.DAE.n = psat_obj.DAE.n+3;
   case 5
    a.slip(i) = psat_obj.DAE.n + 1;
    a.e1r(i) = psat_obj.DAE.n + 2;
    a.e1m(i) = psat_obj.DAE.n + 3;
    a.e2r(i) = psat_obj.DAE.n + 4;
    a.e2m(i) = psat_obj.DAE.n + 5;
    psat_obj.DAE.n = psat_obj.DAE.n+5;
  end
end
