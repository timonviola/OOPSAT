function windup(a,psat_obj)

if ~a.n, return, end

fm_windup(a.alpha,a.con(:,13),a.con(:,14),'td',psat_obj)
