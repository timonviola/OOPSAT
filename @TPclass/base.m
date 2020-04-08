function a = base(a,psat_obj)

if ~a.n, return, end

a.con(:,9) = a.con(:,9)./a.con(:,2)*psat_obj.Settings.mva;
a.con(:,10) = a.con(:,10)./a.con(:,2)*psat_obj.Settings.mva;

