function idx = pqdisplay(a,psat_obj)

idx = 0;

for i = 1:a.n
  bpv = findbus(psat_obj.PV,a.bus(i));
  bsw = findbus(psat_obj.SW,a.bus(i));
  bpq = a.u(i)*a.con(i,4) > 0;
  if isempty(bpv) && isempty(bsw) && bpq
    idx = a.bus(i);
    break
  end
end
