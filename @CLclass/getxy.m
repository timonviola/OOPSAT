function [x,y] = getxy(a,bus,x,y)

if ~a.n, return, end

buses = zeros(a.n,1);
buses(a.psat_obj.Exc) = psat_obj.Exc.bus(a.con(a.psat_obj.Exc,2));
buses(a.psat_obj.Svc) = psat_obj.Svc.bus(a.con(a.psat_obj.Svc,2));

h = find(ismember(buses,bus));

if ~isempty(h)
  x = [x; a.Vs(h)];
end
