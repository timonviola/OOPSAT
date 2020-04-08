function Glcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.Gl = psat_obj.DAE.Gl + sparse(a.ws,1,wspeed(a),psat_obj.DAE.m,1);
