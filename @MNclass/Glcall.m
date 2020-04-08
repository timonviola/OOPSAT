function Glcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);

psat_obj.DAE.Gl = psat_obj.DAE.Gl + ...
         sparse(a.bus, 1, a.u.*a.con(:,4).*V.^a.con(:,6),psat_obj.DAE.m,1) + ...
         sparse(a.vbus,1, a.u.*a.con(:,5).*V.^a.con(:,7),psat_obj.DAE.m,1);
