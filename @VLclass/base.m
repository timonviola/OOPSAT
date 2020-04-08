function p = base(p,psat_obj)
if ~p.n, return, end

p.con(:,6) = p.con(:,6).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,7) = p.con(:,7).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,8) = p.con(:,8).*p.con(:,2)/psat_obj.Settings.mva;
p.con(:,9) = p.con(:,9).*p.con(:,2)/psat_obj.Settings.mva;
