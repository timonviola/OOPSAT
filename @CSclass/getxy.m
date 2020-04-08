function [x,y] = getxy(a,bus,x,y,psat_obj)

if ~a.n, return, end

h = find(ismember(a.bus,bus));

if ~isempty(h)
  vw = psat_obj.Wind.vw(a.wind(h));
  ws = psat_obj.Wind.ws(a.wind(h));
  x = [x; a.omega_t(h); a.omega_m(h); a.gamma(h); a.e1r(h); a.e1m(h); vw];
  y = [y; ws];
end
