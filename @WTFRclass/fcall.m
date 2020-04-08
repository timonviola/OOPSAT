function fcall(p,psat_obj)

if ~p.n, return, end

% COMO YA HICE EN EL g.call HAY QUE DEFINIR TODAS LAS VARIABLES Y
% MOSTRAR SU ESTADO ACTUAL CON EL psat_obj.DAE.x O psat_obj.DAE.y

% VARIABLES DE ESTADO INTERNAS

Dfm = psat_obj.DAE.x(p.Dfm);
x = psat_obj.DAE.x(p.x);
csi = psat_obj.DAE.x(p.csi);
pfw = psat_obj.DAE.x(p.pfw);
pwa = psat_obj.DAE.y(p.pwa);

% VARIABLES DE ESTADO Y ALGEBRAICAS? EXTERNAS.

we = psat_obj.DAE.x(p.we);
Df = psat_obj.DAE.x(p.Df);

% DE NUEVO HAY QUE DEFINIR LOS PARAMETROS Y SU NUMERO DE COLUMNA.

Tr = p.con(:, 3);
Tw = p.con(:, 4);
R = p.con(:, 5);
we_max = p.con(:, 6);
we_min = p.con(:, 7);
KI = p.con(:, 8);
KP = p.con(:, 9);
csi_max = p.con(:, 10);
csi_min = p.con(:, 11);
TA = p.con(:, 12);
pw_max = p.con(:, 13);
pw_min = p.con(:, 14);

we_ref = p.dat(:, 1);

% Ecuaciones
%
% (2)  diff(deltafm') - diff(deltafm) = deltafm'/Tw
% (3)  diff(deltaf) = (deltafm - deltaf)/Tr
% (4)  diff(pci) = (kci*pf-pci)/Tci
% (8)  diff(pfw) = (pfw*-pfw)/Ta
% (9)  diff(kcn*pf*-pcn)/Tcn
% (12) diff(we)= [1/(2*He*we)]*(pin-pout)

% AHORA HACIENDO USO DEL psat_obj.DAE.f SE ESCRIBEN LAS ECUACIONES
% DIFERENCIALES.

psat_obj.DAE.f(p.Dfm) = p.u.*(Df - 1 - Dfm)./Tr;
psat_obj.DAE.f(p.x) = -p.u.*(Dfm + x)./Tw;
psat_obj.DAE.f(p.csi) = p.u.*KI.*(we_ref - we);
psat_obj.DAE.f(p.pfw) = p.u.*(pwa - pfw)./TA;

% dejo al anti windup como estaba.
% anti-windup limiter
fm_windup(p.csi, csi_max, csi_min, 'f',psat_obj)
