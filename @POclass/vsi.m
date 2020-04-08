function out = vsi(a,psat_obj)

out = zeros(a.n,1);

SIv  = find(a.type == 1);  % V
SIPs = find(a.type == 2);  % Pij
SIPr = find(a.type == 3);  % Pji
SIIs = find(a.type == 4);  % Iij
SIIr = find(a.type == 5);  % Iji
SIQs = find(a.type == 6);  % Qij
SIQr = find(a.type == 7);  % Qji

if SIPs, Ps = pjflows(psat_obj.Line,1,a.idx(SIPs),1,psat_obj); end
if SIPr, Pr = pjflows(psat_obj.Line,2,a.idx(SIPr),1,psat_obj); end
if SIIs, Is = pjflows(psat_obj.Line,3,a.idx(SIIs),1,psat_obj); end
if SIIr, Ir = pjflows(psat_obj.Line,4,a.idx(SIIr),1,psat_obj); end
if SIQs, Qs = pjflows(psat_obj.Line,5,a.idx(SIQs),1,psat_obj); end
if SIQr, Qr = pjflows(psat_obj.Line,6,a.idx(SIQr),1,psat_obj); end

if SIv , out(SIv)  = psat_obj.DAE.y(a.idx(SIv)); end
if SIPs, out(SIPs) = Ps; end
if SIPr, out(SIPr) = Pr; end
if SIIs, out(SIIs) = Is; end
if SIIr, out(SIIr) = Ir; end
if SIQs, out(SIQs) = Qs; end
if SIQr, out(SIQr) = Qr; end
