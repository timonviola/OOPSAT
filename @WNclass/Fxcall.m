function Fxcall(a,psat_obj)

if ~a.n, return, end

k = 1./a.con(:,4);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.vw,a.vw,k,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.vw,a.ws,k,psat_obj.DAE.n,psat_obj.DAE.m);
