function gcall(p,psat_obj)

if ~p.n, return, end

psat_obj.DAE.g(p.bus) = p.u.*p.con(:,4) + psat_obj.DAE.g(p.bus);
psat_obj.DAE.g(p.vbus) = p.u.*p.con(:,5) + psat_obj.DAE.g(p.vbus);
if psat_obj.Settings.forcepq
    return
end
a = find((psat_obj.DAE.y(p.vbus) < p.con(:,7) & p.con(:,8) & p.u) | p.shunt);
b = find(psat_obj.DAE.y(p.vbus) > p.con(:,6) & p.con(:,8) & p.u);
if ~isempty(a)
  k = p.bus(a);
  h = p.vbus(a);
  psat_obj.DAE.g(k) = p.con(a,4).*psat_obj.DAE.y(h).*psat_obj.DAE.y(h)./p.con(a,7)./p.con(a,7) ...
      + psat_obj.DAE.g(k) - p.con(a,4);
  psat_obj.DAE.g(h) = p.con(a,5).*psat_obj.DAE.y(h).*psat_obj.DAE.y(h)./p.con(a,7)./p.con(a,7) ...
      + psat_obj.DAE.g(h) - p.con(a,5);
end
if ~isempty(b)
  k = p.bus(b);
  h = p.vbus(b);
  psat_obj.DAE.g(k) = p.con(b,4).*psat_obj.DAE.y(h).*psat_obj.DAE.y(h)./p.con(b,6)./p.con(b,6) + ...
      psat_obj.DAE.g(k) - p.con(b,4);
  psat_obj.DAE.g(h) = p.con(b,5).*psat_obj.DAE.y(h).*psat_obj.DAE.y(h)./p.con(b,6)./p.con(b,6) + ...
      psat_obj.DAE.g(h) - p.con(b,5);
end
