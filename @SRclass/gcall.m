function gcall(a,psat_obj)

if ~a.n, return, end

id = psat_obj.DAE.x(a.Id);
iq = psat_obj.DAE.x(a.Iq);
V = a.u.*psat_obj.DAE.y(a.vbus);
theta = psat_obj.DAE.y(a.bus);
delta = psat_obj.DAE.x(a.delta);
cdt = cos(delta-theta);
sdt = sin(delta-theta);

psat_obj.DAE.g = psat_obj.DAE.g - sparse(a.bus,1,V.*sdt.*id+V.*cdt.*iq,psat_obj.DAE.m,1) ...
        - sparse(a.vbus,1,V.*cdt.*id-V.*sdt.*iq,psat_obj.DAE.m,1);
