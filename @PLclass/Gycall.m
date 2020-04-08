function Gycall(a,psat_obj)

if ~a.n, return, end


V = psat_obj.DAE.y(a.vbus);

if psat_obj.Settings.init
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.vbus,psat_obj.DAE.lambda*a.u.*(2*a.con(:,5).*V + ...
                             a.con(:,6)),psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.vbus,psat_obj.DAE.lambda*a.u.*(2*a.con(:,8).*V + ...
                             a.con(:,9)),psat_obj.DAE.m,psat_obj.DAE.m);
elseif ~isempty(a.init)
  i = a.init;
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse( ...
      a.bus(i),a.vbus(i), ...
      psat_obj.DAE.lambda*a.u(i).*(2*a.con(i,5).*V(i)+a.con(i,6)),psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse( ...
      a.vbus(i),a.vbus(i), ...
      psat_obj.DAE.lambda*a.u(i).*(2*a.con(i,8).*V(i)+a.con(i,9)),psat_obj.DAE.m,psat_obj.DAE.m);
end
