function a = noqlim(a,idx,psat_obj)

if isnumeric(idx)
  a.con(idx,6) = 999*psat_obj.Settings.mva;
  a.con(idx,7) = -999*psat_obj.Settings.mva;
elseif strcmp(idx,'all')
  a.con(:,6) = 999*psat_obj.Settings.mva;
  a.con(:,7) = -999*psat_obj.Settings.mva;
end
