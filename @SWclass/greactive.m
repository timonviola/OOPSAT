function greactive(p,psat_obj)


if ~p.n, return, end

idx = p.vbus(find(p.u));

if isempty(idx),return, end

psat_obj.DAE.g(idx) = 0;
