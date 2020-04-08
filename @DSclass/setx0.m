function a = setx0(a,psat_obj)

if ~a.n, return, end

delta = a.u.*psat_obj.DAE.x(a.delta);
omega = a.u.*psat_obj.DAE.x(a.omega);
Tm = a.u.*psat_obj.DAE.y(a.pm);

K12 = a.con(:,14);
K23 = a.con(:,15);
K34 = a.con(:,16);

psat_obj.DAE.x(a.omega_HP) = omega;
psat_obj.DAE.x(a.omega_IP) = omega;
psat_obj.DAE.x(a.omega_LP) = omega;
psat_obj.DAE.x(a.omega_EX) = omega;

psat_obj.DAE.x(a.delta_EX) = delta;
psat_obj.DAE.x(a.delta_LP) = (Tm+K34.*delta)./K34;
psat_obj.DAE.x(a.delta_IP) = (Tm+K23.*psat_obj.DAE.x(a.delta_LP))./K23;
psat_obj.DAE.x(a.delta_HP) = (Tm+K12.*psat_obj.DAE.x(a.delta_IP))./K12;

psat_obj.fm_disp('Initialization of Dynamic Shafts completed.')
