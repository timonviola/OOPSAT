function gcall(a,psat_obj)

if ~a.n, return, end

delta = zeros(a.n,1);
omega = ones(a.n,1);

for i = 1:a.n
  idx = a.syn{i};
  delta(i) = sum(a.M(idx).*psat_obj.DAE.x(a.dgen(idx)))/a.Mtot(i);
  omega(i) = sum(a.M(idx).*psat_obj.DAE.x(a.wgen(idx)))/a.Mtot(i);
end

psat_obj.DAE.g = psat_obj.DAE.g ...
    + sparse(a.delta,1,delta-psat_obj.DAE.y(a.delta),psat_obj.DAE.m,1) ...
    + sparse(a.omega,1,omega-psat_obj.DAE.y(a.omega),psat_obj.DAE.m,1);

