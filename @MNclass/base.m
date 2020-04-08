function a = base(a,psat_obj)

if ~a.n, return, end
if ~isempty(a.init)
  k = a.init;
  a.con(k,4) = a.con(k,4).*a.con(k,2)/psat_obj.Settings.mva;
  a.con(k,5) = a.con(k,5).*a.con(k,2)/psat_obj.Settings.mva;
end
