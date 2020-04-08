function a = setx0(a,psat_obj)

if ~a.n, return, end

for i = 1:a.n
  idx = a.syn{i};
  psat_obj.DAE.y(a.delta(i)) = sum(a.M(idx).*psat_obj.DAE.x(a.dgen(idx)))/a.Mtot(i);
end
psat_obj.DAE.y(a.omega) = 1;

psat_obj.fm_disp('Initialization of COI completed.')


