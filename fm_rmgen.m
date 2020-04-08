function  check = fm_rmgen(idx,psat_obj)
% FM_RMGEN finds and remove static generators
%
% CHECK = FM_RMGEN(IDX)
%       IDX   = bus index where to look for generators
%       CHECK = 0 -> no generator found
%       CHECK = 1 -> found generator
%
%Author:    Federico Milano
%Date:      27-Dec-2005
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

persistent local_idx

check = 1;

if idx == -1
  local_idx = [];
  return
end

if ~idx, return, end

if ~isempty(local_idx)
  if ~isempty(find(local_idx == idx))
    return
  else
    local_idx = [local_idx;idx];
  end
else
  local_idx = [local_idx;idx];
end

idx_sw = findbus(psat_obj.SW,idx);
idx_pv = findbus(psat_obj.PV,idx);
idx_pq = findgen(psat_obj.PQ,idx);

psat_obj.SW = remove(psat_obj.SW,idx_sw);
psat_obj.PV = remove(psat_obj.PV,idx_pv,psat_obj);
psat_obj.PQ = remove(psat_obj.PQ,idx_pq,'force');

if isempty(idx_pv) && isempty(idx_sw) && isempty(idx_pq)
  fm_disp([' * * Error: No static generator found at bus <', ...
           psat_obj.Bus.names{idx},'>'])
  check = 0;
end
