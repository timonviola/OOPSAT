function windup(a,psat_obj)

if ~a.n, return, end

fm_windup(a.vp,a.con(:,9),a.con(:,10),'td',psat_obj)
fm_windup(a.vq,a.con(:,11),a.con(:,12),'td',psat_obj)
fm_windup(a.iq,a.con(:,13),a.con(:,14),'td',psat_obj)
