function Gycall(p,psat_obj)
if ~p.n, return, end

if psat_obj.Settings.pv2pq
  psat_obj.fm_setgy(p.vbus(find(~p.pq & p.u)));
else
  psat_obj.fm_setgy(p.vbus(find(p.u)));
end
