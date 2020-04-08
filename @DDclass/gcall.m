function gcall(a,psat_obj)

if ~a.n, return, end

omega_m = psat_obj.DAE.x(a.omega_m);
iqs = psat_obj.DAE.x(a.iqs);
idc = psat_obj.DAE.x(a.idc);
iqc = psat_obj.DAE.y(a.iqc);

pwa = psat_obj.DAE.y(a.pwa);
ids = psat_obj.DAE.y(a.ids);
V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);

rs = a.con(:,6);
xd = a.con(:,7);
xq = a.con(:,8);
psip = a.con(:,9);

vds = -rs.*ids+omega_m.*xq.*iqs;
vqs = -rs.*iqs-omega_m.*(xd.*ids-psip);
ps = vds.*ids+vqs.*iqs;
%qc = V.*idc./ct+st.*ps./ct;
iq = (ps + V.*st.*idc)./V./ct;
iq = min(iq, a.con(:,21));
iq = max(iq, a.con(:,22));
qc = V.*(idc.*ct+iqc.*st);
qc = min(qc, a.con(:,23));
qc = max(qc, a.con(:,24));

psat_obj.DAE.g = psat_obj.DAE.g ...
        - sparse(a.bus,1,ps,psat_obj.DAE.m,1) ...
        - sparse(a.vbus,1,qc,psat_obj.DAE.m,1) ...
        + sparse(a.iqc,1,iq-iqc,psat_obj.DAE.m,1) ...
        + sparse(a.ids,1,vqs.*ids-vds.*iqs - a.dat(:,4),psat_obj.DAE.m,1) ...
        + sparse(a.pwa, 1, a.u.*a.con(:,3).*max(min(2*omega_m-1,1),0)/psat_obj.Settings.mva - pwa, psat_obj.DAE.m, 1);
