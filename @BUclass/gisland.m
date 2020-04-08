function gisland(a,psat_obj)

if isempty(a.island), return, end

kkk = a.island;
jjj = kkk+a.n;

psat_obj.DAE.g(kkk) = 0;
psat_obj.DAE.g(jjj) = 0;

psat_obj.DAE.y(kkk) = 0;
psat_obj.DAE.y(jjj) = 1e-6;
