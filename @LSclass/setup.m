function a = setup(a, psat_obj)

if isempty(a.con)
  a.store = [];
  return
end

a.n = length(a.con(:,1));
[a.bus1,a.v1] = getbus(psat_obj.Bus,a.con(:,1));
[a.bus2,a.v2] = getbus(psat_obj.Bus,a.con(:,2));

if length(a.con(1,:)) < a.ncol
  a.u = ones(a.n,1);
else
  a.u = a.con(:,a.ncol);
end

a.store = a.con;

psat_obj.Settings.nseries = psat_obj.Settings.nseries + a.n;
