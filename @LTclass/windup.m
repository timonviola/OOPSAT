function windup(a,psat_obj)

if ~a.n, return, end

fm_windup(a.mc,a.con(:,9),a.con(:,10),'td',psat_obj)
