function a = base(a,psat_obj)

if ~a.n, return, end

fm_errv(a.con(:,3),'Shunt',a.bus,psat_obj);
Vb2new = getkv(psat_obj.Bus,a.bus,2);
Vb2old = a.con(:,3).*a.con(:,3);
a.con(:,5) = a.con(:,2).*Vb2new.*a.con(:,5)./Vb2old/psat_obj.Settings.mva;
a.con(:,6) = a.con(:,2).*Vb2new.*a.con(:,6)./Vb2old/psat_obj.Settings.mva;
