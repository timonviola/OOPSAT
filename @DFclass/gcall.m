function gcall(a,psat_obj)

if ~a.n, return, end

omega_m = psat_obj.DAE.x(a.omega_m);
idr = psat_obj.DAE.x(a.idr);
iqr = psat_obj.DAE.x(a.iqr);

pwa = psat_obj.DAE.y(a.pwa);
V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);

rs = a.con(:,6);
rr = a.con(:,8);
xm = a.con(:,10);

as = rs.^2+a.dat(:,1).^2;
a13 = rs./as;
a23 = a.dat(:,1)./as;
a33 = a.dat(:,2);

vds = -V.*st;
vqs =  V.*ct;

ids =  -a13.*(vds-xm.*iqr)-a23.*(vqs+xm.*idr);
iqs =   a23.*(vds-xm.*iqr)-a13.*(vqs+xm.*idr);

vdr = -rr.*idr+(1-omega_m).*(a33.*iqr+xm.*iqs);
vqr = -rr.*iqr-(1-omega_m).*(a33.*idr+xm.*ids);

p = vds.*ids+vqs.*iqs+vdr.*idr+vqr.*iqr;
q = -V.*(xm.*idr+V)./a.dat(:,1);

psat_obj.DAE.g = psat_obj.DAE.g ...
        - sparse(a.bus,1, a.u.*p,psat_obj.DAE.m,1) ...
        - sparse(a.vbus,1, a.u.*q,psat_obj.DAE.m,1) ...
        + sparse(a.vref,1, a.u.*a.dat(:,6)-psat_obj.DAE.y(a.vref),psat_obj.DAE.m,1) ...
        + sparse(a.pwa, 1, a.u.*a.con(:,3).*max(min(2*omega_m-1,1),0)/psat_obj.Settings.mva - pwa, psat_obj.DAE.m, 1);
