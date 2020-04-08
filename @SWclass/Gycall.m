function Gycall(p,psat_obj)

if ~p.n, return, end

psat_obj.fm_setgy(p.bus(find(p.u)));

if psat_obj.Settings.pv2pq
  psat_obj.fm_setgy(p.vbus(find(~p.dq & p.u)));
else
  psat_obj.fm_setgy(p.vbus(find(p.u)));
end
