function gcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
dw = psat_obj.DAE.y(a.dw);

psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.bus,1,a.u.*a.con(:,2).*(V.^a.con(:,3)).* ...
                         (1+dw).^a.con(:,4),psat_obj.DAE.m,1);
psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.vbus,1,a.u.*a.con(:,5).*(V.^a.con(:,6)).* ...
                         (1+dw).^a.con(:,7),psat_obj.DAE.m,1);
psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.dw,1,psat_obj.DAE.x(a.x)+(psat_obj.DAE.y(a.bus)-a.a0)./a.con(:,8)/ ...
                       (2*pi*psat_obj.Settings.freq)-dw,psat_obj.DAE.m,1);
