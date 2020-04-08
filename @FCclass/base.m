function a = base(a,psat_obj)

if ~a.n, return, end

Vn = a.con(:,3);
Vb2 = getkv(psat_obj.Bus,a.bus,2);

fm_errv(Vn,'Solid Oxide Fuel Cell',a.bus)

Vn2 = Vn.*Vn;

a.con(:,26) = Vn2.*a.con(:,26)./a.con(:,2)./Vb2*psat_obj.Settings.mva;
