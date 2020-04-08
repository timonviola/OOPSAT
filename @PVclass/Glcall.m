function Glcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.Gl(p.bus) = psat_obj.DAE.Gl(p.bus) - p.u.*p.con(:,4);
