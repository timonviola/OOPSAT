function gcall(a,psat_obj)

if ~a.n, return, end


id = psat_obj.DAE.x(a.id);
iq = psat_obj.DAE.x(a.iq);


V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);


vd = -V.*st;
vq =  V.*ct;



p = vd.*id + vq.*iq;
q = vq.*id - vd.*iq;

psat_obj.DAE.g = psat_obj.DAE.g ...
        - sparse(a.bus,1, a.u.*p,psat_obj.DAE.m,1) ...
        - sparse(a.vbus,1, a.u.*q,psat_obj.DAE.m,1)...
        + sparse(a.vref,1, a.u.*a.dat(:,1)-psat_obj.DAE.y(a.vref),psat_obj.DAE.m,1);

