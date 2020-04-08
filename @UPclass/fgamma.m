function g = fgamma(a,psat_obj)

V = psat_obj.DAE.y(a.v1).*exp(i*psat_obj.DAE.y(a.bus1)) - ...
    psat_obj.DAE.y(a.v2).*exp(i*psat_obj.DAE.y(a.bus2));

theta = angle(V)-pi/2;

g = atan2(psat_obj.DAE.x(a.vq),psat_obj.DAE.x(a.vp))+theta-psat_obj.DAE.y(a.bus1);
