function a = dynidx(a,psat_obj)

if ~a.n, return, end

m = 7;
k = [0:m:m*(a.n-1)]';

a.Ik   = psat_obj.DAE.n + 1 + k;
a.Vk   = psat_obj.DAE.n + 2 + k;
a.pH2  = psat_obj.DAE.n + 3 + k;
a.pH2O = psat_obj.DAE.n + 4 + k;
a.pO2  = psat_obj.DAE.n + 5 + k;
a.qH2  = psat_obj.DAE.n + 6 + k;
a.m    = psat_obj.DAE.n + 7 + k;

psat_obj.DAE.n = psat_obj.DAE.n + m*a.n;
