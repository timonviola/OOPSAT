function p = base(p,psat_obj)

if ~p.n, return, end

V1 = getkv(psat_obj.Bus,p.bus1,1);
V2 = getkv(psat_obj.Bus,p.bus2,1);

VL1 = p.con(:,4);
VL2 = p.con(:,5);

fm_errv(VL1,'Phase Shifting Tranformer',p.bus1,psat_obj)
fm_errv(VL2,'Phase Shifting Tranformer',p.bus2,psat_obj)

Vb2new = V1.*V1;
Vb2old = VL1.*VL1;

p.con(:,10)  = p.con(:,10).*p.con(:,3)/psat_obj.Settings.mva;
p.con(:,11)  = Settings.mva*Vb2old.*p.con(:,11)./p.con(:,3)./Vb2new;
p.con(:,12)  = Settings.mva*Vb2old.*p.con(:,12)./p.con(:,3)./Vb2new;
