function fcall(a,psat_obj)

if ~a.n, return, end

Idc = psat_obj.DAE.x(a.Idc);
xr = psat_obj.DAE.x(a.xr);
xi = psat_obj.DAE.x(a.xi);
Vrdc = psat_obj.DAE.y(a.Vrdc);
Vidc = psat_obj.DAE.y(a.Vidc);
yr = psat_obj.DAE.y(a.yr);
yi = psat_obj.DAE.y(a.yi);
V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);

Ki = a.u.*a.con(:,13);
Rdc = a.dat(:,1);
Tdc = a.dat(:,2);

uI = a.u.*(a.dat(:,9)+a.dat(:,10));
uV = a.u.*a.dat(:,11);

psat_obj.DAE.f(a.Idc) = a.u.*((Vrdc-Vidc)./Rdc-Idc)./Tdc;
psat_obj.DAE.f(a.xr) = Ki.*(yr-uI.*Idc-uV.*Vrdc);
psat_obj.DAE.f(a.xi) = Ki.*(uI.*Idc+uV.*Vidc-yi);

% anti-windup limiter
fm_windup(a.xr,a.dat(:,3),a.dat(:,4),'f')
fm_windup(a.xi,a.dat(:,5),a.dat(:,6),'f')
