function p = base(p,psat_obj)

if ~p.n, return, end

mva = getvar(Syn,p.syn,'mva');

p.con(:,2) = psat_obj.Settings.mva*p.con(:,2)./mva;
p.con(:,3) = psat_obj.Settings.mva*p.con(:,3)./mva;
p.con(:,4) = psat_obj.Settings.mva*p.con(:,4)./mva;
p.con(:,5) = psat_obj.Settings.mva*p.con(:,5)./mva;

p.con(:,6) = mva.*p.con(:,6)/psat_obj.Settings.mva;
p.con(:,7) = mva.*p.con(:,7)/psat_obj.Settings.mva;
p.con(:,8) = mva.*p.con(:,8)/psat_obj.Settings.mva;
p.con(:,9) = mva.*p.con(:,9)/psat_obj.Settings.mva;

p.con(:,10) = mva.*p.con(:,10)/psat_obj.Settings.mva;
p.con(:,11) = mva.*p.con(:,11)/psat_obj.Settings.mva;
p.con(:,12) = mva.*p.con(:,12)/psat_obj.Settings.mva;
p.con(:,13) = mva.*p.con(:,13)/psat_obj.Settings.mva;

p.con(:,14) = mva.*p.con(:,14)/psat_obj.Settings.mva;
p.con(:,15) = mva.*p.con(:,15)/psat_obj.Settings.mva;
p.con(:,16) = mva.*p.con(:,16)/psat_obj.Settings.mva;
p.con(:,17) = mva.*p.con(:,17)/psat_obj.Settings.mva;

p.con(:,18) = psat_obj.Settings.mva*p.con(:,18)./mva;
