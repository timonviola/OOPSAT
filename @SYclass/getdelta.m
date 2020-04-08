function delta = getdelta(a,psat_obj)

delta = [];

if ~a.n, return, end

delta = a.u.*psat_obj.DAE.x(a.delta);
