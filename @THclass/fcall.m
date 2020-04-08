function fcall(a,psat_obj)

if ~a.n, return, end

T = psat_obj.DAE.x(a.T);
x = psat_obj.DAE.x(a.x);
G = psat_obj.DAE.y(a.G);
V = psat_obj.DAE.y(a.vbus);
Ki = a.con(:,4);
Ti = a.con(:,5);
T1 = a.con(:,6);
Ta = a.con(:,7);
Tref = a.con(:,8);
K1 = a.con(:,10);

psat_obj.DAE.f(a.T) = a.u.*(Ta - T + K1.*G.*V.^2)./T1;
psat_obj.DAE.f(a.x) = a.u.*Ki.*(Tref-T)./Ti;

% anti-windup limits
fm_windup(a.x,a.con(:,9),0,'f',psat_obj)
