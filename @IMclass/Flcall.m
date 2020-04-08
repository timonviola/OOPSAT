function Flcall(a,psat_obj)

if ~a.n, return, end

slip = psat_obj.DAE.x(a.slip);
u = getstatus(a);
A = a.dat(:,1);
B = a.dat(:,2);
C = a.dat(:,3);
i2Hm = u.*a.dat(:,4);
Tm = A + slip.*(B + slip.*C);

% check if the motor can work as a brake
z = slip < 1 | a.con(:,19) | psat_obj.DAE.f(a.slip) ~= 0;

psat_obj.DAE.Fl = psat_obj.DAE.Fl + sparse(a.slip,1,z.*Tm.*i2Hm,psat_obj.DAE.n,1);
