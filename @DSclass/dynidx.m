function a = dynidx(a,psat_obj)

if ~a.n, return, end

m = 8;
k = [0:m:m*(a.n-1)]';

a.delta_HP = psat_obj.DAE.n + 1 + k;
a.omega_HP = psat_obj.DAE.n + 2 + k;
a.delta_IP = psat_obj.DAE.n + 3 + k;
a.omega_IP = psat_obj.DAE.n + 4 + k;
a.delta_LP = psat_obj.DAE.n + 5 + k;
a.omega_LP = psat_obj.DAE.n + 6 + k;
a.delta_EX = psat_obj.DAE.n + 7 + k;
a.omega_EX = psat_obj.DAE.n + 8 + k;

psat_obj.DAE.n = psat_obj.DAE.n + m*a.n;

a.delta = psat_obj.Syn.delta(a.syn);
a.omega = psat_obj.Syn.omega(a.syn);
a.pm = psat_obj.Syn.pm(a.syn);
