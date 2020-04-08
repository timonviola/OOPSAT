function out = isdelta(a,idx)

out = 0;

if ~a.n, return, end

if psat_obj.Settings.hostver > 7
  out = ~isempty(find(a.u.*a.gamma == idx,1));
else
  out = ~isempty(find(a.u.*a.gamma == idx));
end