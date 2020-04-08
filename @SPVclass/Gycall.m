function Gycall(a,psat_obj)

if ~a.n, return, end


id = psat_obj.DAE.x(a.id);
iq = psat_obj.DAE.x(a.iq);

V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);


vd = -V.*st;
vq =  V.*ct;



dPdtet = vd.*iq - vq.*id;
dPdv = iq.*ct - id.*st;
dQdtet = vd.*id + vq.*iq;
dQdv = id.*ct + iq.*st;

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.bus, a.bus, a.u.*dPdtet,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.bus, a.vbus,a.u.*dPdv,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vbus,a.bus,a.u.*dQdtet,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vbus,a.vbus,a.u.*dQdv,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vref,a.vref,1,psat_obj.DAE.m,psat_obj.DAE.m);
