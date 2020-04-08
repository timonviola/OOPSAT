function a = swreset(a,idx,psat_obj)

if ~a.n, return, end


if isnumeric(idx)
  a.pg(idx) = a.store(idx,10).*a.con(:,2)/psat_obj.Settings.mva;
elseif strcmp(idx,'all')
  a.pg = a.store(:,10).*a.con(:,2)/psat_obj.Settings.mva;  
end
