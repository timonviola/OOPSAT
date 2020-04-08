function Glcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.Gl = psat_obj.DAE.Gl + sparse(p.bus,1,p.u.*p.con(:,3),psat_obj.DAE.m,1);
psat_obj.DAE.Gl = psat_obj.DAE.Gl + sparse(p.vbus,1,p.u.*p.con(:,4),psat_obj.DAE.m,1);

