function  u = fm_genstatus(idx,psat_obj)
% FM_GENSTATUS finds and remove static generators
%
% CHECK = FM_GENSTATUS(IDX)
%       IDX   = bus index where to look for generators
%       U = 0 -> generator off-line (or no generator found)
%       U = 1 -> generator on-line
%
%Author:    Federico Milano
%Date:      24-Aug-2007
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

u = zeros(length(idx),1);

for i = 1:length(idx)
  k = idx(i);
  if k <= 0, continue, end
  idx_sw = findbus(psat_obj.SW,k);
  idx_pv = findbus(psat_obj.PV,k);
  idx_pq = findgen(psat_obj.PQ,k);

  if isempty(idx_sw)
    u_sw = 0;
  else
    u_sw = psat_obj.SW.u(idx_sw);
  end

  if isempty(idx_pv)
    u_pv = 0;
  else
    u_pv = psat_obj.PV.u(idx_pv);
  end

  if isempty(idx_pq)
    u_pq = 0;
  else
    u_pq = psat_obj.PQ.u(idx_pq);
  end

  u(i) = u_sw || u_pv || u_pq;
end
