function p = fcall(p,psat_obj)

if ~p.n, return, end

t2 = p.con(:,3) == 2;
ta = p.con(:,4) == 2;
i2 = find(t2);

x0 = psat_obj.DAE.y(p.x0);
x1 = psat_obj.DAE.x(p.x1);
Pref = psat_obj.DAE.y(p.pref);

[Ps,Qs,Pr,Qr] = flows(psat_obj.Line,psat_obj,'pq',p.line);
[Ps,Qs,Pr,Qr] = flows(p,psat_obj,Ps,Qs,Pr,Qr,'tcsc');

Ki = p.con(:,13);

fx2 = p.u.*t2.*Ki.*(Pref - Ps - ta.*Pr);
psat_obj.DAE.f(p.x2(i2)) = fx2(i2);
psat_obj.DAE.f(p.x1) = p.u.*(x0-x1)./p.con(:,9);

% anti-windup limit
fm_windup(p.x1,p.con(:,10),p.con(:,11),'f',psat_obj)

% update B
p.B = btcsc(p,psat_obj);
