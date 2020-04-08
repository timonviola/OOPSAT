function delta = approxdelta(a,psat_obj)


delta = a.u.*(psat_obj.DAE.x(a.delta)-a.con(:,9).*psat_obj.DAE.y(a.pm));
