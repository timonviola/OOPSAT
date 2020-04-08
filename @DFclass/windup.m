function windup(a,psat_obj)

if ~a.n, return, end

fm_windup(a.theta_p,999*ones(a.n,1),zeros(a.n,1),'td',psat_obj)
fm_windup(a.iqr,a.dat(:,8),a.dat(:,9),'td',psat_obj)
fm_windup(a.idr,a.dat(:,10),a.dat(:,11),'td',psat_obj)
