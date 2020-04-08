function windup(a,psat_obj)

idx = find(~a.con(:,19));
if ~isempty(idx)
  fm_windup(a.slip(idx),1,-1e3,'td',psat_obj);
end
