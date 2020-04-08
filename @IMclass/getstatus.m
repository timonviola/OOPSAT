function u = getstatus(a,psat_obj)


u = (a.con(:,18) <= psat_obj.DAE.t | a.z) & a.u;
