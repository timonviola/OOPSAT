function gcall(p,psat_obj)

if ~p.n, return, end

V = psat_obj.DAE.y(p.vbus);
V2 = p.u.*V.*V;

psat_obj.DAE.g = psat_obj.DAE.g + ...
        sparse(p.bus,1,p.dat(:,1).*V2,psat_obj.DAE.m,1) - ...
        sparse(p.vbus,1,p.dat(:,2).*V2,psat_obj.DAE.m,1);
