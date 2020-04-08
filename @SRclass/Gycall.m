function Gycall(a,psat_obj)

if ~a.n, return, end

id = a.u.*psat_obj.DAE.x(a.Id);
iq = a.u.*psat_obj.DAE.x(a.Iq);
V = psat_obj.DAE.y(a.vbus);
theta = psat_obj.DAE.y(a.bus);
delta = psat_obj.DAE.x(a.delta);
cdt = cos(delta-theta);
sdt = sin(delta-theta);

psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.bus,V.*cdt.*id-V.*sdt.*iq,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.bus,a.vbus,sdt.*id+cdt.*iq,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vbus,a.bus,V.*sdt.*id+V.*cdt.*iq,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.vbus,sdt.*iq-cdt.*id,psat_obj.DAE.m,psat_obj.DAE.m);
