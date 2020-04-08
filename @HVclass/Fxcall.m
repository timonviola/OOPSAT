function Fxcall(a,psat_obj)


if ~a.n, return, end

k = 0.995*3*sqrt(2)/pi;
c = 3/pi;

Idc = psat_obj.DAE.x(a.Idc);
xr = psat_obj.DAE.x(a.xr);
xi = psat_obj.DAE.x(a.xi);

cosa = psat_obj.DAE.y(a.cosa);
cosg = psat_obj.DAE.y(a.cosg);
phir = psat_obj.DAE.y(a.phir);
phii = psat_obj.DAE.y(a.phii);
Vrdc = psat_obj.DAE.y(a.Vrdc);
Vidc = psat_obj.DAE.y(a.Vidc);
yr = psat_obj.DAE.y(a.yr);
yi = psat_obj.DAE.y(a.yi);
V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);

xtr = a.con(:,9);
xti = a.con(:,10);
mr  = a.con(:,11);
mi  = a.con(:,12);
Ki  = a.con(:,13);
Kp  = a.con(:,14);
Rdc = a.dat(:,1);
Tdc = a.dat(:,2);

za = cosa < a.dat(:,3) & cosa > a.dat(:,4) & a.u; 
zg = cosg < a.dat(:,5) & cosg > a.dat(:,6) & a.u; 
zr = yr < a.con(:,21) & yr > a.con(:,22) & a.u; 
zi = yi < a.con(:,23) & yi > a.con(:,24) & a.u; 
zxr = xr < a.dat(:,3) & xr > a.dat(:,4) & a.u; 
zxi = xi < a.dat(:,5) & xi > a.dat(:,6) & a.u; 

V0 = a.con(:,28);
uI = a.u.*(a.dat(:,9)+a.dat(:,10));
uV = a.u.*a.dat(:,11);

psat_obj.DAE.Fx = psat_obj.DAE.Fx ...
         - sparse(a.Idc,a.Idc,1./Tdc,psat_obj.DAE.n,psat_obj.DAE.n) ...
         - sparse(a.xr,a.Idc,zxr.*Ki.*uI,psat_obj.DAE.n,psat_obj.DAE.n) ...
         - sparse(a.xr,a.xr,~zxr+1e-6,psat_obj.DAE.n,psat_obj.DAE.n) ...
         - sparse(a.xi,a.xi,~zxi+1e-6,psat_obj.DAE.n,psat_obj.DAE.n) ...
         + sparse(a.xi,a.Idc,zxi.*Ki.*uI,psat_obj.DAE.n,psat_obj.DAE.n);

psat_obj.DAE.Fy = psat_obj.DAE.Fy ...
         + sparse(a.Idc,a.Vrdc,a.u./Rdc./Tdc,psat_obj.DAE.n,psat_obj.DAE.m) ...
         - sparse(a.Idc,a.Vidc,a.u./Rdc./Tdc,psat_obj.DAE.n,psat_obj.DAE.m) ...
         + sparse(a.xr,a.yr,zxr.*zr.*Ki,psat_obj.DAE.n,psat_obj.DAE.m) ...
         - sparse(a.xi,a.yi,zxi.*zi.*Ki,psat_obj.DAE.n,psat_obj.DAE.m) ...
         - sparse(a.xr,a.Vrdc,zxr.*Ki.*uV,psat_obj.DAE.n,psat_obj.DAE.m) ...
         + sparse(a.xi,a.Vidc,zxi.*Ki.*uV,psat_obj.DAE.n,psat_obj.DAE.m);

psat_obj.DAE.Gx = psat_obj.DAE.Gx ...
         + sparse(a.bus1,a.Idc,Vrdc,psat_obj.DAE.m,psat_obj.DAE.n) ...
         - sparse(a.bus2,a.Idc,Vidc,psat_obj.DAE.m,psat_obj.DAE.n) ...
         + sparse(a.v1,a.Idc,k*V1.*mr.*sin(phir),psat_obj.DAE.m,psat_obj.DAE.n) ...
         + sparse(a.v2,a.Idc,k*V2.*mi.*sin(phii),psat_obj.DAE.m,psat_obj.DAE.n) ...
         + sparse(a.cosa,a.xr,zxr.*za,psat_obj.DAE.m,psat_obj.DAE.n) ...
         - sparse(a.cosa,a.Idc,za.*Kp.*uI,psat_obj.DAE.m,psat_obj.DAE.n) ...
         - sparse(a.Vrdc,a.Idc,c*a.u.*xtr,psat_obj.DAE.m,psat_obj.DAE.n) ...
         + sparse(a.cosg,a.xi,zxi.*zg,psat_obj.DAE.m,psat_obj.DAE.n) ...
         + sparse(a.cosg,a.Idc,zg.*Kp.*uI,psat_obj.DAE.m,psat_obj.DAE.n) ...
         - sparse(a.Vidc,a.Idc,c*a.u.*xti,psat_obj.DAE.m,psat_obj.DAE.n);
