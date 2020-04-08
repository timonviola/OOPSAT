function [Ps,Qs,Pr,Qr] = flows(a,psat_obj,Ps,Qs,Pr,Qr,varargin)

if ~a.n, return, end

if nargin == 5
  type = 'all';
else
  type = varargin{1};
end

% update B
B = btcsc(a,psat_obj);

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
ss = sin(psat_obj.DAE.y(a.bus1)-psat_obj.DAE.y(a.bus2));
cc = cos(psat_obj.DAE.y(a.bus1)-psat_obj.DAE.y(a.bus2));

P1 = V1.*V2.*ss.*B;

switch type
 case 'all'
  Ps(a.line) = Ps(a.line) + P1;
  Pr(a.line) = Pr(a.line) - P1;
  Qs(a.line) = Qs(a.line) + V1.*(V1-V2.*cc).*B;
  Qr(a.line) = Qr(a.line) + V2.*(V2-V1.*cc).*B;
 case 'tcsc'
  Ps = Ps + P1;
  Pr = Pr - P1;
  Qs = Qs + V1.*(V1-V2.*cc).*B;
  Qr = Qr + V2.*(V2-V1.*cc).*B;  
end
