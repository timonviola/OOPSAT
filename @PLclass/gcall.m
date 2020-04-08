function gcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);

if Settings.init
  psat_obj.DAE.g = psat_obj.DAE.g + ...
          sparse(a.bus,1,psat_obj.DAE.lambda*a.u.*((a.con(:,5).*V+a.con(:,6)).*V+a.con(:,7)),psat_obj.DAE.m,1) + ...
          sparse(a.vbus,1,psat_obj.DAE.lambda*a.u.*((a.con(:,8).*V+a.con(:,9)).*V+a.con(:,10)),psat_obj.DAE.m,1);
elseif ~isempty(a.init)
  i = a.init;
  psat_obj.DAE.g = psat_obj.DAE.g + ...
          sparse(a.bus(i),1,psat_obj.DAE.lambda*a.u(i).*((a.con(i,5).*V(i)+a.con(i,6)).*V(i)+a.con(i,7)),psat_obj.DAE.m,1) + ...
          sparse(a.vbus(i),1,psat_obj.DAE.lambda*a.u(i).*((a.con(i,8).*V(i)+a.con(i,9)).*V(i)+a.con(i,10)),psat_obj.DAE.m,1);
end
