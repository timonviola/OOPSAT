function fcall(a,psat_obj)

if ~a.n, return, end

x = psat_obj.DAE.x(a.x);
w = psat_obj.DAE.x(a.w);
theta = psat_obj.DAE.y(a.bus);
iTf = a.u./a.con(:,2);
iTw = a.u./a.con(:,3);
theta0 = a.dat(:,1);
k = a.dat(:,2);

psat_obj.DAE.f(a.x) = (k.*(theta-theta0)-x).*iTf;
psat_obj.DAE.f(a.w) = (-x+k.*(theta-theta0)+1-w).*iTw;
