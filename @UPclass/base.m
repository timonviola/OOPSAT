function p = base(p,psat_obj)

if ~p.n, return, end

fm_errv(p.con(:,4),'Upfc',p.bus1)
Vb = getkv(psat_obj.Bus,p.bus1,1);
p.con(:,9)  = p.con(:,9).*p.con(:,4)./Vb;
p.con(:,10) = p.con(:,10).*p.con(:,4)./Vb;
p.con(:,11) = p.con(:,11).*p.con(:,4)./Vb;
p.con(:,12) = p.con(:,12).*p.con(:,4)./Vb;

[p.xcs,p.y] = factsbase(psat_obj.Line,p.line,p.Cp,'UPFC',psat_obj);

