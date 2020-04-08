function fcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
P0 = a.dat(:,1);
Q0 = a.dat(:,2);
V0 = a.dat(:,3);

psat_obj.DAE.f(a.xp) = -a.u.*(psat_obj.DAE.x(a.xp)./a.con(:,5) - ...
                     P0.*(V./V0).^a.con(:,7) + ...
                     P0.*(V./V0).^a.con(:,8));
psat_obj.DAE.f(a.xq) = -a.u.*(psat_obj.DAE.x(a.xq)./a.con(:,6) - ...
                     Q0.*(V./V0).^a.con(:,9) + ...
                     Q0.*(V./V0).^a.con(:,10));
