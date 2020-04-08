function p = base(p,psat_obj)

if ~p.n, return, end

fm_errv(p.con(:,3),'PQ Bus',p.bus,psat_obj);
Vb = getkv(psat_obj.Bus,p.bus,1);
p.con(:,4) = p.con(:,4).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,5) = p.con(:,5).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,6) = p.con(:,6).*p.con(:,3)./Vb;
p.con(:,7) = p.con(:,7).*p.con(:,3)./Vb;
p.P0 = p.u.*p.con(:,4);
p.Q0 = p.u.*p.con(:,5);
