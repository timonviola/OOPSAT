function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.vcs = zeros(a.n,1);  
a.vpi = zeros(a.n,1);  
a.v0 = zeros(a.n,1);
a.pref = zeros(a.n,1);

for i = 1:a.n
  if a.con(i,2) == 3
    a.vcs(i,1) = psat_obj.DAE.n + 1;
    a.vpi(i,1) = psat_obj.DAE.n + 2;
    psat_obj.DAE.n = psat_obj.DAE.n + 2;
  else
    a.vcs(i,1) = psat_obj.DAE.n + 1;
    psat_obj.DAE.n = psat_obj.DAE.n + 1;
  end
  a.v0(i) = psat_obj.DAE.m + 1;
  a.pref(i) = psat_obj.DAE.m + 2;
  psat_obj.DAE.m = psat_obj.DAE.m + 2;
end

