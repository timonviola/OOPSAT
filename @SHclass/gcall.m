function gcall(p,psat_obj)


if ~p.n, return, end

V = psat_obj.DAE.y(p.vbus);
V2 = p.u.*V.*V;

psat_obj.DAE.g = psat_obj.DAE.g + ...
        sparse(p.bus,1,p.con(:,5).*V2,psat_obj.DAE.m,1) - ...
        sparse(p.vbus,1,p.con(:,6).*V2,psat_obj.DAE.m,1);
