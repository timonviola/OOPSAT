function xfirst(a,psat_obj)

if ~a.n, return, end

I0 = a.con(:,26);
P0 = a.con(:,27);
V0 = a.con(:,28);
uI = a.u.*a.dat(:,9);
uP = a.u.*a.dat(:,10);
uV = a.u.*a.dat(:,11);

psat_obj.DAE.y(a.cosa) = 0.5*a.u.*(a.dat(:,3)+a.dat(:,4));
psat_obj.DAE.y(a.cosg) = a.u.*a.dat(:,5); % minimum gamma
psat_obj.DAE.y(a.Vrdc) = uI + uP + uV.*V0;
psat_obj.DAE.y(a.Vidc) = uI + uP + uV.*V0;
psat_obj.DAE.y(a.yr) = uI.*I0 + uP.*P0 + uV.*V0;
psat_obj.DAE.y(a.yi) = uI.*I0 + uP.*P0 + uV.*V0;
psat_obj.DAE.y(a.phir) = 0.5;
psat_obj.DAE.y(a.phii) = 0.5;

psat_obj.DAE.x(a.Idc) = uI.*I0 + uP.*P0;
psat_obj.DAE.x(a.xr) = psat_obj.DAE.y(a.cosa);
psat_obj.DAE.x(a.xi) = psat_obj.DAE.y(a.cosg);
