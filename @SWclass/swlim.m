function [qmax,qmin] = swlim(a,psat_obj)


if ~a.n
  qmax = [];
  qmin = [];
  return
end

qmax = find(psat_obj.Bus.Qg(a.bus) > a.con(:,6) & a.u);
qmin = find(psat_obj.Bus.Qg(a.bus) < a.con(:,7) & a.u);

