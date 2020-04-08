function gcall(a,psat_obj)

if ~a.n, return, end

type = a.con(:,4);
a1 = find(type == 1);
a2 = find(type == 2);
a3 = find(type == 3);
a4 = find(type == 4);
a5 = find(type == 5);
a6 = find(type == 6);

Vs = a.u.*psat_obj.DAE.y(a.Vs);
Kw = a.con(:,7);
Tw = a.con(:,8);
T1 = a.con(:,9);
T2 = a.con(:,10);
T3 = a.con(:,11);
T4 = a.con(:,12);

VSI = vsi(a);

A = T1./T2;
B = 1 - A;
C = T3./T4;
D = 1 - C;

S1 = Kw.*VSI - psat_obj.DAE.x(a.v1);

if a1, psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.svc,1,Vs(a1),psat_obj.DAE.m,1); end
if a2, psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.tcsc,1,Vs(a2).*a.kr,psat_obj.DAE.m,1); end
if a3, psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.statcom,1,Vs(a3),psat_obj.DAE.m,1); end
if a4, psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.sssc,1,Vs(a4),psat_obj.DAE.m,1); end
if a5, psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.upfc,1,Vs([a5;a5;a5]).*a.z,psat_obj.DAE.m,1); end
if a6, psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.dfig,1,Vs(a6),psat_obj.DAE.m,1); end

psat_obj.DAE.y(a.Vs) = min(psat_obj.DAE.y(a.Vs), a.con(:,5));
psat_obj.DAE.y(a.Vs) = max(psat_obj.DAE.y(a.Vs), a.con(:,6));

u = a.u & psat_obj.DAE.y(a.Vs) < a.con(:,5) & psat_obj.DAE.y(a.Vs) > a.con(:,6);

psat_obj.DAE.g(a.Vs) = u.*(A.*C.*S1 + B.*C.*psat_obj.DAE.x(a.v2) + D.*psat_obj.DAE.x(a.v3) - psat_obj.DAE.y(a.Vs));
%psat_obj.DAE.g(a.Vs) = u.*(A.*C.*S1 + C.*psat_obj.DAE.x(a.v2) + psat_obj.DAE.x(a.v3) - psat_obj.DAE.y(a.Vs));

