function p = base(p,psat_obj)

if ~p.n, return, end

fm_errv(p.con(:,3),'Statcom',p.bus,psat_obj)

Iold = p.con(:,2)./p.con(:,3);
Inew = psat_obj.Settings.mva./getkv(psat_obj.Bus,p.bus,1);

p.con(:,7) = p.con(:,7).*Iold./Inew;
p.con(:,8) = p.con(:,8).*Iold./Inew;

