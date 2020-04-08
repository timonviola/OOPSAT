function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.bcv = zeros(a.n,1);
a.alpha = zeros(a.n,1);
a.vm = zeros(a.n,1);
a.vref = zeros(a.n,1);
a.q = zeros(a.n,1);

type = a.con(:,5);

for i = 1:a.n
  if type(i) == 1
    a.bcv(i) = psat_obj.DAE.n + 1;
    psat_obj.DAE.n = psat_obj.DAE.n + 1;
  elseif type(i) == 2
    a.alpha(i) = psat_obj.DAE.n + 1;
    a.vm(i) = psat_obj.DAE.n + 2;
    psat_obj.DAE.n = psat_obj.DAE.n + 2;
  end
  a.vref(i) = psat_obj.DAE.m + 1;
  a.q(i) = psat_obj.DAE.m + 2;
  psat_obj.DAE.m = psat_obj.DAE.m + 2;
end

a.bcv = a.bcv(find(a.bcv));
a.alpha = a.alpha(find(a.alpha));
a.vm = a.vm(find(a.vm));
a.Be = zeros(a.n,1);

