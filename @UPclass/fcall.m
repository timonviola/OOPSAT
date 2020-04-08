function fcall(p,psat_obj)

if ~p.n, return, end

V1 = psat_obj.DAE.y(p.v1);
vp = psat_obj.DAE.x(p.vp);
vq = psat_obj.DAE.x(p.vq);
iq = psat_obj.DAE.x(p.iq);

Kr = p.con(:,7);
Tr = p.con(:,8);

psat_obj.DAE.f(p.vp) = p.u.*(psat_obj.DAE.y(p.vp0)-vp)./Tr; 
psat_obj.DAE.f(p.vq) = p.u.*(psat_obj.DAE.y(p.vq0)-vq)./Tr;
psat_obj.DAE.f(p.iq) = p.u.*(Kr.*(psat_obj.DAE.y(p.vref)-V1)-iq)./Tr;

% anti-windup limits
fm_windup(p.vp,p.con(:,9), p.con(:,10),'f')
fm_windup(p.vq,p.con(:,11),p.con(:,12),'f')
fm_windup(p.iq,p.con(:,13),p.con(:,14),'f')
