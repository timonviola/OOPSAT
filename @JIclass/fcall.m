function fcall(a,psat_obj)

if ~a.n, return, end

x = psat_obj.DAE.x(a.x);
V1 = psat_obj.DAE.y(a.vbus);
iTf = a.u./a.con(:,5);

psat_obj.DAE.f(a.x) = -(V1.*iTf+x).*iTf;
