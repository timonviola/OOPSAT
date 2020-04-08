function a = fcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.f(a.x) = -a.u.*psat_obj.DAE.y(a.dw)./a.con(:,8);
