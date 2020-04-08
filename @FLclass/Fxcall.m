function Fxcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.x,a.x,~a.u,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.x,a.dw,a.u./a.con(:,8),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.dw,a.x,a.u,psat_obj.DAE.m,psat_obj.DAE.n);
