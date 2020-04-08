function windup(a,psat_obj)

if ~a.n, return, end

fm_windup(a.ist,a.con(:,7),a.con(:,8),'td',psat_obj)
