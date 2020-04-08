function Gycall(a,psat_obj)

if ~a.n, return, end

omega_m = psat_obj.DAE.x(a.omega_m);
idr = psat_obj.DAE.x(a.idr);
iqr = psat_obj.DAE.x(a.iqr);

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

pv = -ids.*st  + iqs.*ct;
pt = -ids.*vqs + iqs.*vds;

idsv =  a13.*st  - a23.*ct;
idst =  a13.*vqs - a23.*vds;
iqsv = -a23.*st  - a13.*ct;
iqst = -a23.*vqs - a13.*vds;

k = (1-omega_m).*xm;

vdrv = k.*iqsv;
vdrt = k.*iqst;
vqrv = -k.*idsv;
vqrt = -k.*idst;

j11 = vds.*idst + vqs.*iqst + vdrt.*idr + vqrt.*iqr + pt;
j12 = vds.*idsv + vqs.*iqsv + vdrv.*idr + vqrv.*iqr + pv;
j22 = -(xm.*idr+2*V)./a.dat(:,1);

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.bus, a.bus, a.u.*j11,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.bus, a.vbus,a.u.*j12,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vbus,a.vbus,a.u.*j22,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.vref,a.vref,1,psat_obj.DAE.m,psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.pwa,a.pwa,1,psat_obj.DAE.m,psat_obj.DAE.m);
