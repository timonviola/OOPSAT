function Fxcall(p,psat_obj)

if ~p.n, return, end

idx = p.vbus(find(p.u));

if isempty(idx),return, end

psat_obj.DAE.Fy(:,idx) = 0;
psat_obj.DAE.Gx(idx,:) = 0;
