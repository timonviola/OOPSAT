function a = setup(a,psat_obj)

if isempty(a.con)
  a.store = [];
  return
end

a.n = length(a.con(:,1));
a.bus = getint(psat_obj.Bus,a.con(:,1));
if length(a.con(1,:)) < a.ncol
  a.con(:,a.ncol) = ones(a.n,1);
end 
a.Pr = zeros(a.n,1);
a.u = a.con(:,a.ncol);
a.store = a.con;
