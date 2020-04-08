function [Ps,Qs,Pr,Qr] = flows(a,psat_obj,Ps,Qs,Pr,Qr,varargin)


if ~a.n, return, end

if nargin == 5
  type = 'all';
else
  type = varargin{1};
end

g = fgamma(a);
V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
theta = psat_obj.DAE.y(a.bus1)-psat_obj.DAE.y(a.bus2)+g;
ss = sin(theta);
cc = cos(theta);
c1 = a.u.*sqrt(psat_obj.DAE.x(a.vp).^2+psat_obj.DAE.x(a.vq).^2).*a.y;
switch type
 case 'all'
  Ps(a.line) = Ps(a.line) + c1.*V2.*ss;
  Qs(a.line) = Qs(a.line) + c1.*V1.*cos(g);
  Pr(a.line) = Pr(a.line) - c1.*V2.*ss;
  Qr(a.line) = Qr(a.line) - c1.*V2.*cc;
 case 'upfc'
  Ps = Ps + c1.*V2.*ss;
  Qs = Qs + c1.*V1.*cos(g);
  Pr = Pr - c1.*V2.*ss;
  Qr = Qr - c1.*V2.*cc;  
end
