function Fxcall(a,psat_obj)


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

% psat_obj.DAE.f(psat_obj.DAE.Tc) = a.u.*(G - A.*h.*(Tc - Ta) - Vg.*Ig)./mc./C;

% Fx
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.Tc, a.Tc, A.*h./mc./C, psat_obj.DAE.n, psat_obj.DAE.n);

% Fy
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.Tc, a.Ig, a.u.*Vg./mc./C, psat_obj.DAE.n, psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.Tc, a.G, a.u./mc./C, psat_obj.DAE.n, psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.Tc, a.Vg, a.u.*Ig./mc./C, psat_obj.DAE.n, psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.Tc, a.Ta, a.u.*A.*h./mc./C, psat_obj.DAE.n, psat_obj.DAE.m);


% k = Vg./Ncs + Rs.*Ig./Ncp
% Igeq = Ncp.*(IL - I0.*(exp(Vt.*k./Tc) - 1) - k./Rp); 
% sparse(a.Ig, 1, Iqeq - Ig, psat_obj.DAE.m, 1) + ...
% sparse(a.I0, 1, Dconst.*(Tc.^3).*exp(-a.q*Eg./Tc/a.K) - I0, psat_obj.DAE.m, 1) + ...
% sparse(a.IL, 1, Ac.*(Jsc.*G/1000 + aJsc.*(Tc - 300)) - IL, psat_obj.DAE.m, 1) + ...
% sparse(a.Eg, 1, Eg0 - agap.*Tc.*Tc./(bgap + Tc) - Eg, psat_obj.DAE.m, 1);

% Gx

% eq IL
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.IL, a.Tc, a.u.*(Ac.*aJsc), psat_obj.DAE.m, psat_obj.DAE.n);

% eq Ig
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.Ig, a.Tc, a.u.*(3*Dconst.*(Tc.^2).*exp(-a.q*Eg./Tc/a.K) + ...
                         a.q*Eg.*Dconst.*(Tc.^3).*exp(-a.q*Eg./Tc/a.K)./Tc./Tc/a.K), psat_obj.DAE.m, psat_obj.DAE.n);


% eq I0
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.I0, a.Tc, a.u.*(3*Dconst.*(Tc.^2).*exp(-a.q*Eg./Tc/a.K) + ...
                         a.q*Eg.*Dconst.*(Tc.^3).*exp(-a.q*Eg./Tc/a.K)./Tc./Tc/a.K), psat_obj.DAE.m, psat_obj.DAE.n);

% eq Eg
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.Eg, a.Tc, a.u.*(agap.*Tc.*Tc/(bgap + Tc).^2-2*agap.*Tc/(bgap + Tc)), psat_obj.DAE.m, psat_obj.DAE.n);

