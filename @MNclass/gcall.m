function gcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);

if psat_obj.Settings.init
  psat_obj.DAE.g = psat_obj.DAE.g + ...
          sparse(a.bus,1,psat_obj.DAE.lambda*a.u.*a.con(:,4).*V.^a.con(:,6),psat_obj.DAE.m,1) + ...
          sparse(a.vbus,1,psat_obj.DAE.lambda*a.u.*a.con(:,5).*V.^a.con(:,7),psat_obj.DAE.m,1);
elseif ~isempty(a.init)
  i = a.init;
  psat_obj.DAE.g = psat_obj.DAE.g + ...
          sparse(a.bus(i),1,psat_obj.DAE.lambda*a.u(i).*a.con(i,4).*V(i).^a.con(i,6),psat_obj.DAE.m,1) + ...
          sparse(a.vbus(i),1,psat_obj.DAE.lambda*a.u(i).*a.con(i,5).*V(i).^a.con(i,7),psat_obj.DAE.m,1);
end

