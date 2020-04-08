function adjgen(a,psat_obj)

if ~a.n, return, end

idx = find(a.gen);

if isempty(idx), return, end

p = a.P0(idx);
q = a.Q0(idx);

yp = find((psat_obj.DAE.y(a.vbus(idx)) < a.con(idx,7) & a.con(idx,8) & a.u(idx)) | a.shunt(idx));
yq = find(psat_obj.DAE.y(a.vbus(idx)) > a.con(idx,6) & a.con(idx,8) & a.u(idx));

if ~isempty(yp)
  k = idx(yp);
  h = a.vbus(k);
  v = psat_obj.DAE.y(h).*psat_obj.DAE.y(h);
  p(yp) = p(yp).*v./a.con(k,7)./a.con(k,7);
  q(yp) = q(yp).*v./a.con(k,7)./a.con(k,7);
end

if ~isempty(yq)
  k = idx(yq);
  h = a.vbus(yq);
  v = psat_obj.DAE.y(h).*psat_obj.DAE.y(h);
  p(yq) =  p(yq).*v./a.con(k,6)./a.con(k,6);
  q(yq) =  q(yq).*v./a.con(k,6)./a.con(k,6);
end

psat_obj.Bus.Pg(a.bus(idx)) = psat_obj.Bus.Pg(a.bus(idx)) - p;
psat_obj.Bus.Qg(a.bus(idx)) = psat_obj.Bus.Qg(a.bus(idx)) - q;
psat_obj.Bus.Pl(a.bus(idx)) = psat_obj.Bus.Pl(a.bus(idx)) - p;
psat_obj.Bus.Ql(a.bus(idx)) = psat_obj.Bus.Ql(a.bus(idx)) - q;
