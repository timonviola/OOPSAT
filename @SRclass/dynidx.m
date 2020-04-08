function a = dynidx(a,psat_obj)

if ~a.n, return, end

m = 15;
k = [0:m:m*(a.n-1)]';

a.Id = psat_obj.DAE.n + 1 + k;
a.Iq = psat_obj.DAE.n + 2 + k;
a.If = psat_obj.DAE.n + 3 + k;
a.Edc = psat_obj.DAE.n + 4 + k;
a.Eqc = psat_obj.DAE.n + 5 + k;
a.delta_HP = psat_obj.DAE.n + 6 + k;
a.omega_HP = psat_obj.DAE.n + 7 + k;
a.delta_IP = psat_obj.DAE.n + 8 + k;
a.omega_IP = psat_obj.DAE.n + 9 + k;
a.delta_LP = psat_obj.DAE.n + 10 + k;
a.omega_LP = psat_obj.DAE.n + 11 + k;
a.delta = psat_obj.DAE.n + 12 + k;
a.omega = psat_obj.DAE.n + 13 + k;
a.delta_EX = psat_obj.DAE.n + 14 + k;
a.omega_EX = psat_obj.DAE.n + 15 + k;

psat_obj.DAE.n = psat_obj.DAE.n + m*a.n;
