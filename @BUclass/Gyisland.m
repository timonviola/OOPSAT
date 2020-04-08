function Gyisland(a,psat_obj)

if isempty(a.island), return, end

psat_obj.fm_setgy(a.island);
psat_obj.fm_setgy(a.island+a.n);
