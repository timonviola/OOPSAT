function fcall(p,psat_obj)
if ~p.n, return, end

alpha = psat_obj.DAE.x(p.alpha);
Pm = psat_obj.DAE.x(p.Pm);

Vf = p.u.*psat_obj.DAE.y(p.v1).*exp(i*psat_obj.DAE.y(p.bus1));
Vt = p.u.*psat_obj.DAE.y(p.v2).*exp(i*psat_obj.DAE.y(p.bus2));  
y = admittance(p);
m = p.con(:,15).*exp(i*alpha);
errP = real(Vf.*conj((Vf./m-Vt).*y./conj(m)))-Pm;

Tm = p.con(:,7);
Kp = p.con(:,8);
Ki = p.con(:,9);
Pref = p.u.*p.con(:,10);

psat_obj.DAE.f(p.alpha) = Kp.*errP./Tm+Ki.*(Pm-Pref);
psat_obj.DAE.f(p.Pm) = errP./Tm;

% non-windup limits
fm_windup(p.alpha,p.con(:,13),p.con(:,14),'pf',psat_obj)
