function p = base(p,psat_obj)
if ~p.n, return, end

fm_errv(p.con(:,4),'Sssc',p.bus1,psat_obj)
Vb = getkv(psat_obj.Bus,p.bus1,1);
p.con(:,9)  = p.con(:,9).*p.con(:,4)./Vb;
p.con(:,10) = p.con(:,10).*p.con(:,4)./Vb;

[p.xcs,p.y] = factsbase(psat_obj.Line,p.line,p.Cp,'SSSC');
