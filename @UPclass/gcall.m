function a = gcall(a,psat_obj)

if ~a.n, return, end

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
a1 = psat_obj.DAE.y(a.bus1);
a2 = psat_obj.DAE.y(a.bus2);

vp = psat_obj.DAE.x(a.vp);
vq = psat_obj.DAE.x(a.vq);
iq = psat_obj.DAE.x(a.iq);

a.gamma = fgamma(a);
ss = sin(a1-a2+a.gamma);
cc = cos(a1-a2+a.gamma);

c1 = a.u.*a.y.*sqrt(vp.*vp+vq.*vq);

P1 =  c1.*V2.*ss;
Q1 =  c1.*V1.*cos(a.gamma)-iq.*V1;
Q2 = -c1.*V2.*cc;
  
ty2 = a.con(:,2) == 2;
kp = a.Cp./(1-a.Cp);
Vq0 = a.Vq0 + ty2.*(kp.*V1.*sin(a1-a2)./ss - a.Vq0);

psat_obj.DAE.g = psat_obj.DAE.g ...
        + sparse(a.bus1,1,P1,psat_obj.DAE.m,1) ...
        - sparse(a.bus2,1,P1,psat_obj.DAE.m,1) ...
        + sparse(a.v1,1,Q1,psat_obj.DAE.m,1) ...
        + sparse(a.v2,1,Q2,psat_obj.DAE.m,1); 

psat_obj.DAE.g = psat_obj.DAE.g ...
        + sparse(a.vp0,1,a.Vp0-psat_obj.DAE.y(a.vp0),psat_obj.DAE.m,1) ...
        + sparse(a.vq0,1,Vq0-psat_obj.DAE.y(a.vq0),psat_obj.DAE.m,1) ...
        + sparse(a.vref,1,a.Vref-psat_obj.DAE.y(a.vref),psat_obj.DAE.m,1);
