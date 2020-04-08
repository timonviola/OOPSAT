function greactive(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g(p.vbus(find(p.u))) = 0;
