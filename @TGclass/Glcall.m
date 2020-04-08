function Glcall(p,psat_obj)


if ~p.n, return, end

psat_obj.DAE.Gl = psat_obj.DAE.Gl - sparse(p.pm,1,p.u.*pmech(p),psat_obj.DAE.m,1);
psat_obj.DAE.Gk = psat_obj.DAE.Gk - sparse(p.pm,1,p.u.*pmech(p),psat_obj.DAE.m,1);
