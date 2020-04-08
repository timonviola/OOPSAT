function p = base(p,psat_obj)

if ~p.n, return, end

p.con(:,3) = p.con(:,3).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,4) = p.con(:,4).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,5) = p.con(:,5).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,6) = p.con(:,6).*p.con(:,2)/psat_obj.Settings.mva;
