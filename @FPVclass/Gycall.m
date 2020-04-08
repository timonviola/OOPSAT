function Gycall(a,psat_obj)

Ig = psat_obj.DAE.y(a.Ig);
I0 = psat_obj.DAE.y(a.I0);
IL = psat_obj.DAE.y(a.IL);
Vg = psat_obj.DAE.y(a.Vg);
Eg = psat_obj.DAE.y(a.Eg);
G = psat_obj.DAE.y(a.G);

Tc = psat_obj.DAE.x(a.Tc);

Pn=a.con(:,2);      %   Power rating                    W	60
Vn=a.con(:,3);      %	Voltage rating                  V	16.8
Isc=a.con(:,4);     %   Short Circuit current           A	3.80
Rs=a.con(:,5);      %	Serial Resistence               Ohm	
Rp=a.con(:,6);      %	Shunt Resistance                Ohm	
agap=a.con(:,7);    % 	Thermal coeficient              eV/K	
bgap=a.con(:,8);    %	Thermal coeficient              K	
md=a.con(:,9);      %	Diode factor	-               1.2
Jsc=a.con(:,10);    %	Short circuit surrent density	A/cm2	
aJsc=a.con(:,11);   %	Short circuit density coeficient	A/�C�cm2	
Eg0=a.con(:,12);    % 	Energy Band Gap at 0K           eV	1.12
Ncp=a.con(:,13);    %	N� of parallel cells            int	1
Ncs=a.con(:,14);    %	N� of serial cells              int	36
Ac=a.con(:,15);     %	Cell area                       cm2	
mc=a.con(:,16);     %	masa de c�lula                  kg	
C=a.con(:,17);      %	Capacidad calor�fica m�dulo		
A=a.con(:,18);      %	Area modulo		
h = a.con(:,19);    %   coeficiente conveccion
Ta = a.con(:,20);   %   ambient temperature	

Eg1 = a.dat(:, 1); 
Vt = a.dat(:, 2);
Dconst = a.dat(:, 3); 

% k = Vg./Ncs + Rs.*Ig./Ncp
% Igeq = Ncp.*(IL - I0.*(exp(Vt.*k./Tc) - 1) - k./Rp); 
% sparse(a.Ig, 1, Iqeq - Ig, psat_obj.DAE.m, 1) + ...
% sparse(a.I0, 1, Dconst.*(Tc.^3).*exp(-a.q*Eg./Tc/a.K) - I0, psat_obj.DAE.m, 1) + ...
% sparse(a.IL, 1, Ac.*(Jsc.*G/1000 + aJsc.*(Tc - 300)) - IL, psat_obj.DAE.m, 1) + ...
% sparse(a.Eg, 1, Eg0 - agap.*Tc.*Tc./(bgap + Tc) - Eg, psat_obj.DAE.m, 1);

% eq IL ACABADO 
% sparse(a.IL, 1, Ac.*(Jsc.*G/1000 + aJsc.*(Tc - 300)) - IL, psat_obj.DAE.m,1)
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.IL, a.IL, 1, psat_obj.DAE.m, psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.IL, a.G, a.u.*Ac.*Jsc/1000, psat_obj.DAE.m, psat_obj.DAE.m);

% eq Ig ACABADO
% k = Vg./Ncs + Rs.*Ig./Ncp
% Igeq = Ncp.*(IL - I0.*(exp(Vt.*k./Tc) - 1) - k./Rp); 
% sparse(a.Ig, 1, Iqeq - Ig, psat_obj.DAE.m, 1)
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.Ig, a.Ig, Ncp.*(((-I0.*Vt.*Rs)./(Tc.*Ncp)).*(exp(Vt.*k./Tc))-1)-(Rs./(Ncp.*Rp)), psat_obj.DAE.m, psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.Ig, a.I0, a.u.*(Ncp.*(-(exp(Vt.*k./Tc)-1))),psat_obj.DAE.m, psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.Ig, a.IL, a.u.*Ncp, psat_obj.DAE.m, psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.Ig, a.Vg, a.u.*(Ncp.*(((-I0.*Vt)./(Tc.*Ncs)).*(exp(Vt.*k./Tc))-(1./(Ncs.*Rp)))), psat_obj.DAE.m, psat_obj.DAE.m);

% eq I0 ACABADO
% sparse(a.I0, 1, Dconst.*(Tc.^3).*exp(-a.q*Eg./Tc/a.K) - I0, psat_obj.DAE.m, 1) + ...
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.I0, a.I0, 1, psat_obj.DAE.m, psat_obj.DAE.m);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.I0, a.Eg, a.u.*a.q*Dconst.*(Tc.^3).*exp(-a.q*Eg./Tc/a.K)./Tc/a.K, psat_obj.DAE.m, psat_obj.DAE.m);

% eq Eg ACABADO
% sparse(a.Eg, 1, Eg0 - agap.*Tc.*Tc./(bgap + Tc) - Eg, psat_obj.DAE.m, 1);
psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(a.Eg, a.Eg, 1, psat_obj.DAE.m, psat_obj.DAE.m);

