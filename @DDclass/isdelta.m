function out = isdelta(a,idx,psat_obj)

out = 0;

if ~a.n, return, end

if psat_obj.Settings.hostver > 7
  out = ~isempty(find(a.u.*a.theta_p == idx,1));
else
  out = ~isempty(find(a.u.*a.theta_p == idx));
end
