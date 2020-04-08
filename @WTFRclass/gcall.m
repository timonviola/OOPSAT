function gcall(p,psat_obj)

if ~p.n, return, end

%VARIABLES INTERNAS DE ESTADO.

Dfm = psat_obj.DAE.x(p.Dfm);
x = psat_obj.DAE.x(p.x);
csi = psat_obj.DAE.x(p.csi);
pfw = psat_obj.DAE.x(p.pfw);

%VARIABLES EXTERNAS.

we = psat_obj.DAE.x(p.we);
Df = psat_obj.DAE.x(p.Df);

%VARIABLES INTERNAS ALGEBRAICAS.

pf1 = psat_obj.DAE.y(p.pf1);
pwa = psat_obj.DAE.y(p.pwa);
pout = psat_obj.DAE.y(p.pout);

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

% quedan por definir las ecuaciones que se hacen con vectores
% dispersos. Cuidado con los signos!!!

psat_obj.DAE.g = psat_obj.DAE.g ...
        + sparse(p.pf1,  1, p.u.*(x + Dfm)./R - pf1, psat_obj.DAE.m, 1) ...
        + sparse(p.pwa,  1, p.u.*(csi + KP.*(we_ref - we)) - pwa, psat_obj.DAE.m, 1);

psat_obj.DAE.g(p.pout) = (~p.u).*psat_obj.DAE.g(p.pout) + p.u.*(pfw - pout);

% windup-limits

idx = find(we > we_max | we < we_min);
if ~isempty(idx), psat_obj.DAE.y(p.pf1(idx)) = 0; end

idx = find(pout > pfw_max);
if ~isempty(idx)
  psat_obj.DAE.y(p.pout(idx)) = pfw_max(idx); 
end
idx = find(pout < pfw_min);
if ~isempty(idx)
  psat_obj.DAE.y(p.pout(idx)) = pfw_min(idx); 
end
