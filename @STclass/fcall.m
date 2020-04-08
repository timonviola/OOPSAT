function fcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
ist = psat_obj.DAE.x(a.ist);
Kr = a.con(:,5);
Tr = a.con(:,6);

psat_obj.DAE.f(a.ist) = a.u.*(Kr.*(psat_obj.DAE.y(a.vref)-V)-ist)./Tr;  

% anti-windup limit
fm_windup(a.ist,a.con(:,7),a.con(:,8),'f',psat_obj)
