function a = base(a,psat_obj)

if ~a.n, return, end

a.con(:,4) = a.con(:,3).*a.con(:,4)/psat_obj.Settings.mva;
a.con(:,5) = a.con(:,3).*a.con(:,5)/psat_obj.Settings.mva;
a.con(:,7) = a.con(:,3).*a.con(:,7)/psat_obj.Settings.mva;
a.con(:,8) = a.con(:,3).*a.con(:,8)/psat_obj.Settings.mva;

