function Fxcall(p,psat_obj)

if ~p.n, return, end

Vs = psat_obj.DAE.y(p.Vs);
u = p.u & Vs < p.con(:,5) & Vs > p.con(:,6);

Kw = p.u.*p.con(:,7);
Tw = p.con(:,8);
T1 = p.con(:,9);
T2 = p.con(:,10);
T3 = p.con(:,11);
T4 = p.con(:,12);

A = p.u.*T1./T2;
B = p.u - A;
C = p.u.*T3./T4;
D = p.u - C;

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.v1,p.v1,1./Tw,psat_obj.DAE.n,psat_obj.DAE.n);   % df1/dv1
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.v2,p.v1,p.u./T2,psat_obj.DAE.n,psat_obj.DAE.n); % df2/dv1
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.v2,p.v2,1./T2,psat_obj.DAE.n,psat_obj.DAE.n);   % df2/dv2
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.v3,p.v1,A./T4,psat_obj.DAE.n,psat_obj.DAE.n);   % df3/dv1
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(p.v3,p.v2,B./T4,psat_obj.DAE.n,psat_obj.DAE.n);   % df3/dv2
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.v3,p.v3,1./T4,psat_obj.DAE.n,psat_obj.DAE.n);   % df3/dv3

psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.Vs,p.v1,u.*A.*C,psat_obj.DAE.m,psat_obj.DAE.n); % df4/dv1
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.Vs,p.v2,u.*B.*C,psat_obj.DAE.m,psat_obj.DAE.n); % df4/dv2
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.Vs,p.v3,u.*D,psat_obj.DAE.m,psat_obj.DAE.n);    % df4/dv3

K1 = Kw./Tw;
K2 = Kw./T2;
K3 = Kw.*A./T4;

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
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v1(SIv),p.idx(SIv),K1(SIv),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v2(SIv),p.idx(SIv),K2(SIv),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v3(SIv),p.idx(SIv),K3(SIv),psat_obj.DAE.n,psat_obj.DAE.m);
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
  
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v1(S),psat_obj.Line.fr(L),K1(S).*J(S,1),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v1(S),psat_obj.Line.vfr(L),K1(S).*J(S,2),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v1(S),psat_obj.Line.to(L),K1(S).*J(S,3),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v1(S),psat_obj.Line.vto(L),K1(S).*J(S,4),psat_obj.DAE.n,psat_obj.DAE.m);
  
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v2(S),psat_obj.Line.fr(L),K2(S).*J(S,1),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v2(S),psat_obj.Line.vfr(L),K2(S).*J(S,2),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v2(S),psat_obj.Line.to(L),K2(S).*J(S,3),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v2(S),psat_obj.Line.vto(L),K2(S).*J(S,4),psat_obj.DAE.n,psat_obj.DAE.m);
  
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v3(S),psat_obj.Line.fr(L),K3(S).*J(S,1),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v3(S),psat_obj.Line.vfr(L),K3(S).*J(S,2),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v3(S),psat_obj.Line.to(L),K3(S).*J(S,3),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.v3(S),psat_obj.Line.vto(L),K3(S).*J(S,4),psat_obj.DAE.n,psat_obj.DAE.m);
  
end
