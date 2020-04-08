function Gycall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(p.pf1, p.pf1, 1, psat_obj.DAE.m, psat_obj.DAE.m); 
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(p.pwa, p.pwa, 1, psat_obj.DAE.m, psat_obj.DAE.m); 
%psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(p.pout, p.pout, 1, psat_obj.DAE.m, psat_obj.DAE.m);
