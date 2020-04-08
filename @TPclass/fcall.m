function fcall(p,psat_obj)


if ~p.n, return, end

m = psat_obj.DAE.x(p.m);
h = p.u.*p.con(:,4);
k = p.u.*p.con(:,5);

psat_obj.DAE.f(p.m) = -h.*m + k.*(psat_obj.DAE.y(p.vbus)./m - p.con(:,8));

% non-windup limits
fm_windup(p.m,p.con(:,6),p.con(:,7),'pf',psat_obj)
