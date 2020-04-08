function [Ps,Qs,Pr,Qr,varargout] = flows(a,psat_obj,Ps,Qs,Pr,Qr,varargin)

if nargin == 8
  varargout{1} = [varargin{1}; a.bus1];
  varargout{2} = [varargin{2}; a.bus2];
end

if ~a.n, return, end

Idc = a.u.*psat_obj.DAE.x(a.Idc);
phir = a.u.*psat_obj.DAE.y(a.phir);
phii = a.u.*psat_obj.DAE.y(a.phii);
Vrdc = psat_obj.DAE.y(a.Vrdc);
Vidc = psat_obj.DAE.y(a.Vidc);
V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);

k = 0.995*3*sqrt(2)/pi;
mr = a.con(:,11);
mi = a.con(:,12);

P1 = Vrdc.*Idc;
P2 = Vidc.*Idc;
Q1 = k*V1.*mr.*Idc.*sin(phir);
Q2 = k*V2.*mi.*Idc.*sin(phii);

Ps = [Ps; P1];
Pr = [Pr;-P2];
Qs = [Qs; Q1];
Qr = [Qr; Q2];  
