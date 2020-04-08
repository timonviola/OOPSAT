function Gycall(a,lambda,psat_obj)

if ~a.n, return, end


V = psat_obj.DAE.y(a.vbus);

if psat_obj.Settings.init
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus,a.vbus,psat_obj.DAE.lambda*a.u.*a.con(:,4).* ...
                             a.con(:,6).*V.^(a.con(:,6)-1),psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus,a.vbus,psat_obj.DAE.lambda*a.u.*a.con(:,5).* ...
                             a.con(:,7).*V.^(a.con(:,7)-1),psat_obj.DAE.m,psat_obj.DAE.m);
elseif a.init
  i = a.init;
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.bus(i),a.vbus(i),psat_obj.DAE.lambda*a.u(i).*a.con(i,4).* ...
                             a.con(i,6).*V(i).^(a.con(i,6)-1),psat_obj.DAE.m,psat_obj.DAE.m);
  psat_obj.DAE.Gy = psat_obj.DAE.Gy + sparse(a.vbus(i),a.vbus(i),psat_obj.DAE.lambda*a.u(i).*a.con(i,5).* ...
                             a.con(i,7).*V(i).^(a.con(i,7)-1),psat_obj.DAE.m,psat_obj.DAE.m);
end
