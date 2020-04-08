function H = hessian(a,ro,psat_obj)
% compute the Hessian matrix of Shunt equations

H = sparse(psat_obj.DAE.m,psat_obj.DAE.m);

if ~a.n, return, end

H = sparse(a.vbus,a.vbus, ...
           2*a.u.*a.con(:,5).*ro(a.bus) - ...
           2*a.u.*a.con(:,6).*ro(a.vbus), ...
           psat_obj.DAE.m,psat_obj.DAE.m);

