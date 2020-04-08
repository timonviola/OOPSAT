function y = ybus(a,buslist,psat_obj)

nb = psat_obj.Bus.n;
y = sparse(nb,nb);

if ~a.n, return, end

idx = [];
for i = 1:a.n,
  jdx = find(buslist ~= a.bus(i));
  if ~isempty(jdx) && a.u(i), 
    idx = [idx; i]; 
  end
end

if isempty(idx), return, end

pqg = a.con(idx,4)./psat_obj.DAE.y(a.vbus(idx))./psat_obj.DAE.y(a.vbus(idx));
pqb = a.con(idx,5)./psat_obj.DAE.y(a.vbus(idx))./psat_obj.DAE.y(a.vbus(idx));

y = sparse(a.bus(idx),a.bus(idx),pqg-sqrt(-1)*pqb,nb,nb);

