function Gycall(a,psat_obj)

if ~a.n, return, end

omega_m = psat_obj.DAE.x(a.omega_m);
iqs = psat_obj.DAE.x(a.iqs);
idc = psat_obj.DAE.x(a.idc);
iqc = psat_obj.DAE.y(a.iqc);

V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
ids = psat_obj.DAE.y(a.ids);

rs = a.con(:,6);
xd = a.con(:,7);
xq = a.con(:,8);
psip = a.con(:,9);

c1 = cos(t);
s1 = sin(t);
t1 = s1./c1;

vds = -rs.*ids+omega_m.*xq.*iqs;
vqs = -rs.*iqs-omega_m.*(xd.*ids-psip);
ps = vds.*ids+vqs.*iqs;
%qc = V.*idc./c1+t1.*ps;
iq = (ps + V.*s1.*idc)./V./c1;
qc = V.*(idc.*c1+iqc.*s1);
uq = qc < a.con(:,23) & qc > a.con(:,24) & a.u;
uc = iq < a.con(:,21) & iq > a.con(:,22) & a.u;
dps_dids = -2*rs.*ids+omega_m.*(xq-xd).*iqs;

psat_obj.DAE.Gy = psat_obj.DAE.Gy ...
         - sparse(a.bus,a.ids,dps_dids,psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.vbus,a.vbus,uq.*(idc.*c1+iqc.*s1),psat_obj.DAE.m,psat_obj.DAE.m) ...
         + sparse(a.vbus,a.bus,uq.*(idc.*s1-iqc.*c1).*V,psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.vbus,a.iqc,uq.*V.*s1,psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.iqc,a.iqc,1,psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.iqc,a.vbus,uc.*ps./V./V./c1,psat_obj.DAE.m,psat_obj.DAE.m) ...
         + sparse(a.iqc,a.bus,uc.*(ps./V./c1./c1.*s1+idc.*(1+t1.*t1)),psat_obj.DAE.m,psat_obj.DAE.m) ...
         + sparse(a.iqc,a.ids,uc.*dps_dids./V./c1,psat_obj.DAE.m,psat_obj.DAE.m) ...
         + sparse(a.ids,a.ids,omega_m.*(psip-2*xd.*ids),psat_obj.DAE.m,psat_obj.DAE.m) ...
         - sparse(a.pwa, a.pwa, 1, psat_obj.DAE.m, psat_obj.DAE.m);
