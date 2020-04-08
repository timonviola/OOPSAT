function windup(a,psat_obj)

if ~a.n, return, end

fm_windup(a.xr,a.dat(:,3),a.dat(:,4),'td',psat_obj)
fm_windup(a.xi,a.dat(:,5),a.dat(:,6),'td',psat_obj)
