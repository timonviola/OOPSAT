function [Ps,Qs,Pr,Qr] = flows(a,psat_obj,Ps,Qs,Pr,Qr,varargin)

if ~a.n, return, end

if nargin == 6
  type = 'all';
else
  type = varargin{1};
end

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
cc = cos(psat_obj.DAE.y(a.bus1)-psat_obj.DAE.y(a.bus2));
den = max(sqrt(V1.^2+V2.^2-2.*V1.*V2.*cc),1e-6*ones(a.n,1));
u = a.u.*psat_obj.DAE.x(a.vcs)./den;
switch type
 case 'all'
  Ps(a.line) = (1+u).*Ps(a.line);
  Pr(a.line) = (1+u).*Pr(a.line);
  Qs(a.line) = (1+u).*Qs(a.line);
  Qr(a.line) = (1+u).*Qr(a.line);
 case 'sssc'
  Ps = (1+u).*Ps;
  Pr = (1+u).*Pr;
  Qs = (1+u).*Qs;
  Qr = (1+u).*Qr;
end
