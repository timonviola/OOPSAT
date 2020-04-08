function fcall(p,psat_obj)

if ~p.n, return, end


psat_obj.DAE.f(p.v) = p.u.*(psat_obj.DAE.y(p.If) - p.con(:,6))./p.con(:,2);

% anti-windup limit
fm_windup(p.v,p.con(:,7),0,'f',psat_obj)
