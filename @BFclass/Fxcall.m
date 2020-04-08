function Fxcall(a,psat_obj)
if ~a.n, return, end

iTf = 1./a.con(:,2);
iTw = 1./a.con(:,3);
k = a.u.*a.dat(:,2);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.x,a.x,-iTf,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.w,a.x,-a.u.*iTw,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.w,a.w,-iTw,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.x,a.bus,k.*iTf,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.w,a.bus,k.*iTw,psat_obj.DAE.n,psat_obj.DAE.m);
