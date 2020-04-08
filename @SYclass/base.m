function p = base(p,psat_obj)

if ~p.n, return, end

fm_errv(p.con(:,3),'Synchronous Machine',p.bus,psat_obj);
Vb2new = getkv(psat_obj.Bus,p.bus,2);
Vb2old = p.con(:,3).*p.con(:,3);
k = psat_obj.Settings.mva*Vb2old./p.con(:,2)./Vb2new;
i = [6:10, 13:15];
for h = 1:length(i)
  p.con(:,i(h))= k.*p.con(:,i(h));
end
p.con(:,18) = p.con(:,18).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,19) = p.con(:,19).*p.con(:,2)/psat_obj.Settings.mva;
