function out = isdelta(a,idx,psat_obj)

out = 0;

if ~a.n, return, end

if psat_obj.Settings.hostver > 7
  out = ~isempty(find((psat_obj.DAE.n+a.delta) == idx,1));
else
  out = ~isempty(find((psat_obj.DAE.n+a.delta) == idx));
end