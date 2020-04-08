function a = setx0(a,psat_obj)

if ~a.n, return, end

%1	k	psat_obj.Bus number	int	
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

a.dat = zeros(a.n, 3)

%%
%% Compute initial value of Tc, Ig, I0, IL, Vg
Vg = psat_obj.DAE.y(a.Vg);
Ig = psat_obj.DAE.y(a.Ig);


%%

% Eg1 -> col. 1
a.dat(:, 1) = Eg0 - agap.*Tk.*Tk./(bgap + Tk);
% Vt -> col. 2
a.dat(:, 2) = a.q./md/a.K;
% Dconst -> col. 3
a.dat(:, 3) = Jsc.*Ac./(300^3*(exp(a.q*V0c./md/a.K) - 1).*exp(-a.q*a.dat(:,1)/300/a.K));

psat_obj.fm_disp('Initialization of Flat Photovoltaic Modules completed.')
