function xfirst(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.x(a.alpha) = 0;
psat_obj.DAE.x(a.Pm) = 0;
idx = find(~a.con(:,7));
if ~isempty(idx)
  warn(a,idx,'Measurement time constant Tm cannot be 0. Tm = 1e-3 will be used.')
  a.con(idx,7) = 1e-3;
end

