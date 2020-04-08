function fcall(p)

if ~p.n, return, end

q1 = psat_obj.DAE.x(p.q1);

psat_obj.DAE.f(p.q1) = p.u.*p.con(:,6).*(p.con(:,5)-psat_obj.DAE.y(p.vbus));

% anti-windup limits
fm_windup(p.q1,p.con(:,8),p.con(:,9),'f',psat_obj)
