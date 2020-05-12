function  [Vx,Vn] = fm_vlim(obj,minV,maxV)
% FM_VLIM determines max and min bus voltages
%
% [VMAX,VMIN] = FM_VLIM(MAXV,MINV)
%       MAXV -> default max voltage
%       MINV -> default min voltage
%       VMAX -> vector of max bus voltages
%       VMIN -> vector of min bus voltages
%
%Author:    Federico Milano
%Date:      26-Dic-2005
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
%Copyright (C) 2002-2019 Federico Milano

Vn = getzeros(obj.Bus);
Vx = getzeros(obj.Bus);

if obj.PQ.n
  Vn(obj.PQ.bus) = vmin(obj.PQ);
  Vx(obj.PQ.bus) = vmax(obj.PQ);
end

if obj.PV.n
  Vn(obj.PV.bus) = vmin(obj.PV);
  Vx(obj.PV.bus) = vmax(obj.PV);
end

if obj.SW.n
  Vn(obj.SW.bus) = vmin(obj.SW);
  Vx(obj.SW.bus) = vmax(obj.SW);
end

Vn(find(Vn == 0)) = minV;
Vx(find(Vx == 0)) = maxV;
