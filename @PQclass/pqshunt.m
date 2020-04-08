function p = pqshunt(p,psat_obj)

if ~p.n, return, end

if ~psat_obj.Settings.pq2z || psat_obj.Settings.init > 1, return, end

if psat_obj.Settings.forcepq
  psat_obj.fm_disp(' * The option "Settings.forcepq" overwrites the option "Settings.pq2z".')
  psat_obj.fm_disp(' * All PQ loads will be forced to consume constant powers.')
  return
end

p.shunt = ~p.gen;
idx = find(p.shunt);
if isempty(idx), return, end
p.con(idx,7) = psat_obj.DAE.y(p.vbus(idx));
p.con(idx,8) = 0;
