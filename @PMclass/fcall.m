function fcall(a,psat_obj)


if ~a.n, return, end

vm = psat_obj.DAE.x(a.vm);
thetam = psat_obj.DAE.x(a.thetam);
V1 = psat_obj.DAE.y(a.vbus);
theta1 = psat_obj.DAE.y(a.bus);

psat_obj.DAE.f(a.vm) = (V1-vm).*a.dat(:,1).*a.u;
psat_obj.DAE.f(a.thetam) = (theta1-thetam).*a.dat(:,2).*a.u;
