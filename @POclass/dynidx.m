function a = dynidx(a,psat_obj)

if ~a.n, return, end

m = 3;
k = [0:m:m*(a.n-1)]';

a.v1 = psat_obj.DAE.n + 1 + k;
a.v2 = psat_obj.DAE.n + 2 + k;
a.v3 = psat_obj.DAE.n + 3 + k;
a.Vs = psat_obj.DAE.m + [1:a.n]';

psat_obj.DAE.n = psat_obj.DAE.n + m*a.n;
psat_obj.DAE.m = psat_obj.DAE.m + a.n;

type = a.con(:,4);
a1 = find(type == 1);
a2 = find(type == 2);
a3 = find(type == 3);
a4 = find(type == 4);
a5 = find(type == 5);
a6 = find(type == 6);

a.svc = psat_obj.Svc.vref(a.con(a1,2));
a.tcsc = psat_obj.Tcsc.x0(a.con(a2,2));
a.statcom = psat_obj.Statcom.vref(a.con(a3,2));
a.sssc = psat_obj.Sssc.v0(a.con(a4,2));
[a.upfc,a.z] = getidx(psat_obj.Upfc,a.con(a5,2));
a.dfig = psat_obj.Dfig.vref(a.con(a6,2));

a.kr = getkr(psat_obj.Tcsc,a.con(a2,2));

% disconnect Pod if the FACTS is off-line
if a.svc,     a.u(a1) = a.u(a1).*psat_obj.Svc.u(a.con(a1,2));     end
if a.tcsc,    a.u(a2) = a.u(a2).*psat_obj.Tcsc.u(a.con(a2,2));    end
if a.statcom, a.u(a3) = a.u(a3).*psat_obj.Statcom.u(a.con(a3,2)); end
if a.sssc,    a.u(a4) = a.u(a4).*psat_obj.Sssc.u(a.con(a4,2));    end
if a.upfc,    a.u(a5) = a.u(a5).*psat_obj.Upfc.u(a.con(a5,2));    end
if a.dfig,    a.u(a6) = a.u(a6).*psat_obj.Dfig.u(a.con(a6,2));    end
