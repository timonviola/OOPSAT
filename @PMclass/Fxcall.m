function Fxcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.vm,a.vm,a.dat(:,1),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.thetam,a.thetam,a.dat(:,2),psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.vm,a.vbus,a.u.*a.dat(:,1),psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.thetam,a.bus,a.u.*a.dat(:,2),psat_obj.DAE.n,psat_obj.DAE.m);
