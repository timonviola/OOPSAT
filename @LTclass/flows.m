function [Ps,Qs,Pr,Qr,varargout] = flows(a,psat_obj,Ps,Qs,Pr,Qr,varargin)

if nargin == 8
  varargout{1} = [varargin{1}; a.bus1];
  varargout{2} = [varargin{2}; a.bus2];
end

if ~a.n, return, end

Vf = a.u.*psat_obj.DAE.y(a.v1).*exp(i*psat_obj.DAE.y(a.bus1));
Vt = a.u.*psat_obj.DAE.y(a.v2).*exp(i*psat_obj.DAE.y(a.bus2));  
y = admittance(a);
m = psat_obj.DAE.y(a.md);

Ss = Vf.*conj((Vf./m-Vt).*y./m);
Sr = Vt.*conj((Vt-Vf./m).*y);

Ps = [Ps; real(Ss)];
Qs = [Qs; imag(Ss)];
Pr = [Pr; real(Sr)];
Qr = [Qr; imag(Sr)];
