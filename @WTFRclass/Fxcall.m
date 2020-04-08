function Fxcall(p,psat_obj)

if ~p.n, return, end

%COMO EN TODOS LOS ANTERIORES DEFINIMOS TODAS LAS VARIABLES NECESARIAS

%INTERNAS DE ESTADO
Dfm = psat_obj.DAE.x(p.Dfm);
x = psat_obj.DAE.x(p.x);
csi = psat_obj.DAE.x(p.csi);
pfw = psat_obj.DAE.x(p.pfw);

%EXTERNAS 
we = psat_obj.DAE.x(p.we);
Df = psat_obj.DAE.x(p.Df);

%INTERNAS ALGEBRAICAS
pf1 = psat_obj.DAE.y(p.pf1);
pwa = psat_obj.DAE.y(p.pwa);
pout = psat_obj.DAE.y(p.pout);

%VARIABLES QUE HAY QUE INTRODUCIR
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
pfw_max = p.con(:, 13);
pfw_min = p.con(:, 14);

we_ref = p.dat(:, 1);

% remove d pref/ d omega_m from wind turbine gradients
psat_obj.DAE.Gx(p.pout, p.we) = diag((~p.u).*diag(psat_obj.DAE.Gx(p.pout,p.we)));

%AHORA EMPEZAMOS A HACER LAS DERIVADAS de las ecuaciones algebraicas
%A CONTINUACION COPIO LAS ECUACIONES PARA HACERLO SOBRE ELLAS
% sparse(p.pf1,  1, p.u.*(x + Dfm)./R - pf1, psat_obj.DAE.m, 1) ...
% sparse(p.pwa,  1, p.u.*(csi + KP.*(we_ref - we)) - pwa, psat_obj.DAE.m, 1) ...
% sparse(p.pout, 1, p.u.*(pfw - pout), psat_obj.DAE.m, 1);

z_csi = csi > csi_min & csi < csi_max & p.u;

%DERIVADA DE LA PRIMERA ECUACION CON RESPECTO A SUS DIFERENTES VARIABLES
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.pf1, p.x, p.u./R, psat_obj.DAE.m, psat_obj.DAE.n); 
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.pf1, p.Dfm, p.u./R, psat_obj.DAE.m, psat_obj.DAE.n);

%DERIVADA DE LA SEGUNDA ECUACION CON RESPECTO A SUS DIFERENTES VARIABLES
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.pwa, p.csi, z_csi, psat_obj.DAE.m, psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.pwa, p.we, p.u.*KP, psat_obj.DAE.m, psat_obj.DAE.n); 

%DERIVADA DE LA TERCERA ECUACION CON RESPECTO A SUS DIFERENTES VARIABLES
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.pout, p.pfw, p.u.*1, psat_obj.DAE.m, psat_obj.DAE.n);
%psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.pout, p.pout, p.u.*1, psat_obj.DAE.m, psat_obj.DAE.n);
%psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.pout, p.we, 0, psat_obj.DAE.m, psat_obj.DAE.n);

%AHORA EMPEZAMOS A HACER LAS DERIVADAS de las ecuaciones diferenciales
%A CONTINUACION COPIO LAS ECUACIONES PARA HACERLO SOBRE ELLAS
% psat_obj.DAE.f(p.Dfm) = p.u.*(Df - Dfm)./Tr;
% psat_obj.DAE.f(p.x) = -p.u.*(Dfm + x)./Tw;
% psat_obj.DAE.f(p.csi) = p.u.*KI.*(we_ref - we);
% psat_obj.DAE.f(p.pfw) = p.u.*(pwa - pwf)./TA;

%PRIMERA ECUACION
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.Dfm, p.Dfm, 1./Tr, psat_obj.DAE.n, psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(p.Dfm, p.Df, p.u./Tr, psat_obj.DAE.n, psat_obj.DAE.n);

%SEGUNDA ECUACION
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.x, p.Dfm, p.u./Tw, psat_obj.DAE.n, psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.x, p.x, 1./Tw, psat_obj.DAE.n, psat_obj.DAE.n);

%TERCERA ECUACION
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.csi, p.we, z_csi.*KI, psat_obj.DAE.n, psat_obj.DAE.n);

%CUARTA ECUACION
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.pfw, p.pfw, 1./TA, psat_obj.DAE.n, psat_obj.DAE.n);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.pfw, p.pwa, p.u./TA, psat_obj.DAE.n, psat_obj.DAE.m);
