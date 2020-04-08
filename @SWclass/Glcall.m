function Glcall(p,psat_obj)

if ~p.n, return, end

jdx = find(p.u);
idx = p.bus(jdx);

if isempty(idx),return, end

psat_obj.DAE.Gl(idx) = psat_obj.DAE.Gl(idx) - p.pg(jdx);
