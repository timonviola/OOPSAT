function gcall(p)

if ~p.n, return, end

q1 = psat_obj.DAE.x(p.q1);
V1 = psat_obj.DAE.y(p.vbus);
Vpref = p.con(:,5);
KI = p.con(:,6);
KP = p.u.*p.con(:,7);

psat_obj.DAE.g = psat_obj.DAE.g + sparse(p.q,1,q1+KP.*(Vpref-V1)-psat_obj.DAE.y(p.q),psat_obj.DAE.m,1);
