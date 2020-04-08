function p = base(p,psat_obj)
if ~p.n, return, end

V1 = getkv(psat_obj.Bus,p.bus1,1);
V2 = getkv(psat_obj.Bus,p.bus2,1);

Vrate = p.con(:,4);

fm_errv(Vrate,'Transmission Line',p.bus1)
fm_errv(Vrate,'Transmission Line',p.bus2)

Vb2new = V1.*V1;
Vb2old = Vrate.*Vrate;

p.con(:,6)  = psat_obj.Settings.mva*Vb2old.*p.con(:,6)./p.con(:,3)./Vb2new;
p.con(:,7)  = psat_obj.Settings.mva*Vb2old.*p.con(:,7)./p.con(:,3)./Vb2new;
p.con(:,8)  = Vb2new.*p.con(:,7).*p.con(:,3)./Vb2old/psat_obj.Settings.mva;
