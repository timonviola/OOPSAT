function Vw = wspeed(a,psat_obj)

Vw = zeros(a.n,1);
t = psat_obj.DAE.t;
if t < 0, t = psat_obj.Settings.t0; end

if t == psat_obj.Settings.t0
  Vw = a.vwa;
else
  for i = 1:a.n
    Vw(i) = interp1(a.speed(i).time,a.speed(i).vw,t);
  end
end
