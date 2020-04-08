function fcall(a,psat_obj)

if ~a.n, return, end

for i = 1:a.n
  idx = a.psat_obj.Syn{i};
  psat_obj.DAE.f = psat_obj.DAE.f + sparse(a.dgen(idx),1,2*pi*psat_obj.Settings.freq*(1-psat_obj.DAE.y(a.omega(i)))*psat_obj.Syn.u(idx),psat_obj.DAE.n,1);
end
