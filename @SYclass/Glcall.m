function Glcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.Gl(a.pm) = -a.pm0.*a.u;
psat_obj.DAE.Gk(a.pm) = -a.pm0.*a.u;
