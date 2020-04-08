function a = pvreset(a,idx,psat_obj)

if ~a.n, return, end

if isnumeric(idx)
  a.con(idx,4) = a.store(idx,4).*a.con(idx,2)/psat_obj.Settings.mva;
elseif strcmp(idx,'all')
  a.con(:,4) = a.store(:,4).*a.con(:,2)/psat_obj.Settings.mva;
end
