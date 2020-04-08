function p = base(p,psat_obj)

if ~p.n, return, end

Sn = psat_obj.Dfig.con(p.gen, 3);

p.con(:, 13) = p.con(:, 13).*Sn/psat_obj.Settings.mva;
p.con(:, 14) = p.con(:, 14).*Sn/psat_obj.Settings.mva;
