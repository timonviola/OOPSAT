function gcall(a,psat_obj)

if ~a.n, return, end

e1r = a.u.*psat_obj.DAE.x(a.e1r);
e1m = a.u.*psat_obj.DAE.x(a.e1m);

V = a.u.*psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);
Vr = -V.*st;
Vm =  V.*ct;

r1 = a.con(:,6);
x0 = a.dat(:,1);
x1 = a.dat(:,2);

B = a.dat(:,8);

k = r1.^2+x1.^2;
a13 = r1./k;
a23 = x1./k;
a33 = x0-x1;

Im = -a23.*(e1r-Vr)+a13.*(e1m-Vm);
Ir =  a13.*(e1r-Vr)+a23.*(e1m-Vm);

psat_obj.DAE.g = psat_obj.DAE.g - sparse(a.bus,1,Vr.*Ir+Vm.*Im,psat_obj.DAE.m,1) ...
        - sparse(a.vbus,1,Vm.*Ir-Vr.*Im+B.*V.*V,psat_obj.DAE.m,1);
