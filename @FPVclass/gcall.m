function gcall(a,psat_obj)

if ~a.n, return, end

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

k = Vg./Ncs + Rs.*Ig./Ncp;

Igeq = a.u.*Ncp.*(IL - I0.*(exp(Vt.*k./Tc) - 1) - k./Rp); 


psat_obj.DAE.g = psat_obj.DAE.g + ...
        sparse(a.Ig, 1, Iqeq - Ig, psat_obj.DAE.m, 1) + ...
        sparse(a.I0, 1, a.u.*Dconst.*(Tc.^3).*exp(-a.q*Eg./Tc/a.K) - I0, psat_obj.DAE.m, 1) + ...
        sparse(a.IL, 1, a.u.*Ac.*(Jsc.*G/1000 + aJsc.*(Tc - 300)) - IL, psat_obj.DAE.m, 1) + ...
        sparse(a.Eg, 1, a.u.*(Eg0 - agap.*Tc.*Tc./(bgap + Tc)) - Eg, psat_obj.DAE.m, 1);
