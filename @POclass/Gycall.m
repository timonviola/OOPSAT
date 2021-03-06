function Gycall(p,psat_obj)

if ~p.n, return, end

Kw = p.con(:,7);
T1 = p.con(:,9);
T2 = p.con(:,10);
T3 = p.con(:,11);
T4 = p.con(:,12);

psat_obj.DAE.Gy = psat_obj.DAE.Gy - sparse(p.Vs,p.Vs,1,psat_obj.DAE.m,psat_obj.DAE.m);

Vs = psat_obj.DAE.y(p.Vs);
u = p.u & Vs < p.con(:,5) & Vs > p.con(:,6);
K4 = u.*Kw.*T1./T2.*T3./T4;

type = p.con(:,4);
a1 = find(type == 1);
a2 = find(type == 2);
a3 = find(type == 3);
a4 = find(type == 4);
a5 = find(type == 5);
a6 = find(type == 6);

if a1, psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.svc,p.Vs(a1),u(a1),psat_obj.DAE.m,psat_obj.DAE.m); end
if a2, psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.tcsc,p.Vs(a2),u(a2).*p.kr,psat_obj.DAE.m,psat_obj.DAE.m); end
if a3, psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.statcom,p.Vs(a3),u(a3),psat_obj.DAE.m,psat_obj.DAE.m); end
if a4, psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.sssc,p.Vs(a4),u(a4),psat_obj.DAE.m,psat_obj.DAE.m); end
if a5, psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.upfc,p.Vs([a5;a5;a5]),u([a5;a5;a5]).*p.z,psat_obj.DAE.m,psat_obj.DAE.m); end
if a6, psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.dfig,p.Vs(a6),u(a6),psat_obj.DAE.m,psat_obj.DAE.m); end

SIv  = find(p.type == 1); % V
SIPs = find(p.type == 2); % Pij
SIPr = find(p.type == 3); % Pji
SIIs = find(p.type == 4); % Iij
SIIr = find(p.type == 5); % Iji
SIQs = find(p.type == 6); % Qij
SIQr = find(p.type == 7); % Qji

S = find(p.type > 1);

if SIPs, JPs = pjflows(psat_obj.Line,psat_obj,1,p.idx(SIPs),2); end
if SIPr, JPr = pjflows(psat_obj.Line,psat_obj,2,p.idx(SIPr),2); end
if SIIs, JIs = pjflows(psat_obj.Line,psat_obj,3,p.idx(SIIs),2); end
if SIIr, JIr = pjflows(psat_obj.Line,psat_obj,4,p.idx(SIIr),2); end
if SIQs, JQs = pjflows(psat_obj.Line,psat_obj,5,p.idx(SIQs),2); end
if SIQr, JQr = pjflows(psat_obj.Line,psat_obj,6,p.idx(SIQr),2); end

if SIv
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.Vs(SIv),p.idx(SIv),K4(SIv),psat_obj.DAE.m,psat_obj.DAE.m);
end

if S

  L = p.idx(S);
  J = zeros(p.n,4);

  if SIPs, J(SIPs,:) = JPs; end
  if SIPr, J(SIPr,:) = JPr; end
  if SIQs, J(SIQs,:) = JQs; end
  if SIQr, J(SIQr,:) = JQr; end
  if SIIs, J(SIIs,:) = JIs; end
  if SIIr, J(SIIr,:) = JIr; end
  
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.Vs(S),psat_obj.Line.fr(L),K4(S).*J(S,1),psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.Vs(S),psat_obj.Line.vfr(L),K4(S).*J(S,2),psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.Vs(S),psat_obj.Line.to(L),K4(S).*J(S,3),psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(p.Vs(S),psat_obj.Line.vto(L),K4(S).*J(S,4),psat_obj.DAE.m,psat_obj.DAE.m);
  
end
