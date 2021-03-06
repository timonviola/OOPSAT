function a = base(a,psat_obj)

if ~a.n, return, end

Vn = a.con(:,3);
Vb = getkv(psat_obj.Bus,a.bus,1);

fm_errv(Vn,'Fault',a.bus)

Vn2 = Vn.*Vn;
Vb2 = Vb.*Vb;

a.con(:,7) = Vn2.*a.con(:,7)./a.con(:,2)./Vb2*psat_obj.Settings.mva;
a.con(:,8) = Vn2.*a.con(:,8)./a.con(:,2)./Vb2*psat_obj.Settings.mva;

z = a.con(:,7)+i*a.con(:,8);
z(find(abs(z) == 0)) = i*1e-6;
y = 1./z;

a.dat = [real(y),imag(y)];
