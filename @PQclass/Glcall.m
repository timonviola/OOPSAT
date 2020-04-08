function Glcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.Gl(p.bus) = psat_obj.DAE.Gl(p.bus) + p.u.*p.con(:,4);
psat_obj.DAE.Gl(p.vbus) = psat_obj.DAE.Gl(p.vbus) + p.u.*p.con(:,5);
