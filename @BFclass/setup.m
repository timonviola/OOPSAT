function a = setup(a,psat_obj)

if isempty(a.con)
  a.store = [];
  return
end

a.n = length(a.con(:,1));
a.bus = getint(psat_obj.Bus,a.con(:,1));
a.dat = zeros(a.n,2);

if length(a.con(1,:)) < a.ncol
  a.u = ones(a.n,1);
else
  a.u = a.con(:,a.ncol);
end

a.store = a.con;
