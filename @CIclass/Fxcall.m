function Fxcall(a,psat_obj)
if ~a.n, return, end

for i = 1:a.n
  idx = a.psat_obj.Syn{i};
  n = length(idx);
  odx = a.omega(i)*ones(n,1);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.dgen(idx),odx,2*pi*psat_obj.Settings.freq*psat_obj.Syn.u(idx),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.delta(i),a.dgen(idx),a.M(idx)/a.Mtot(i),psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.omega(i),a.wgen(idx),a.M(idx)/a.Mtot(i),psat_obj.DAE.m,psat_obj.DAE.n);
end
