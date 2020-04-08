function gcall(a,psat_obj)

if ~a.n, return, end

T = psat_obj.DAE.x(a.T);
x = psat_obj.DAE.x(a.x);
G = psat_obj.DAE.y(a.G);
V = psat_obj.DAE.y(a.vbus);
Kp = a.con(:,3);
Tref = a.con(:,8);
G_max = a.con(:,9);

psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.bus,1,a.u.*G.*V.^2,psat_obj.DAE.m,1);
psat_obj.DAE.g(a.G) = a.u.*(Kp.*(Tref-T) + x - G);

% windup limits
psat_obj.DAE.y(a.G) = min(psat_obj.DAE.y(a.G),G_max);
psat_obj.DAE.y(a.G) = max(psat_obj.DAE.y(a.G),0);
