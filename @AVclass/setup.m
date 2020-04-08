function a = setup(a,psat_obj)

if isempty(a.con)
  a.store = [];
  return
end

a.n = length(a.con(:,1));
a.syn = a.con(:,1);
a.bus = getbus(psat_obj.Syn,a.syn);
a.vbus = a.bus + psat_obj.Bus.n;

if length(a.con(1,:)) < a.ncol
  a.u = ones(a.n,1);
else
  a.u = a.con(:,a.ncol);
end
% the AVR is inactive if the machine is off-line
a.u = a.u.*psat_obj.Syn.u(a.syn);

a.store = a.con;
