function p = resetqlim(p,psat_obj)

if ~p.n, return, end

p.con(:,6) = p.store(:,6).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,7) = p.store(:,7).*p.con(:,2)/psat_obj.Settings.mva;
