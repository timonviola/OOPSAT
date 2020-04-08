function Fxcall(a,psat_obj)

if ~a.n, return, end

iTf = a.u./a.con(:,5);
Kv = a.u.*a.con(:,12);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.x,a.x,-iTf,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.x,a.vbus,-iTf.*iTf,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.vbus,a.x,Kv,psat_obj.DAE.m,psat_obj.DAE.n);
