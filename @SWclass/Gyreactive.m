function Gyreactive(p,psat_obj)

if ~p.n, return, end

psat_obj.fm_setgy(p.vbus(find(p.u)));
