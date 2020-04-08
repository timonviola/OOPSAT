function fcall(p,psat_obj)
if ~p.n, return, end

Vs = psat_obj.DAE.x(p.Vs);
Qgr = p.con(:,7);

psat_obj.DAE.f(p.Vs) = (Qgr.*psat_obj.DAE.y(p.cac)-psat_obj.DAE.y(p.q)).*p.dVsdQ.*p.u;

% anti-windup limits
fm_windup(p.Vs,p.con(:,8),p.con(:,9),'f',psat_obj)
