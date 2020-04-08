function gcall(a,psat_obj)

if ~a.n, return, end

x = psat_obj.DAE.x(a.x);
V1 = psat_obj.DAE.y(a.vbus);
Tf = a.con(:,5);
Plz = a.con(:,6);
Pli = a.con(:,7);
Plp = a.con(:,8);
Qlz = a.con(:,9);
Qli = a.con(:,10);
Qlp = a.con(:,11);
Kv = a.con(:,12);
V = V1./a.dat(:,1);

psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.bus,1,a.u.*(Plz.*V.^2 + Pli.*V+Plp),psat_obj.DAE.m,1) ...
        + sparse(a.vbus,1,a.u.*(Qlz.*V.^2 + Qli.*V+Qlp+Kv.*(x+V1./Tf)),psat_obj.DAE.m,1);
