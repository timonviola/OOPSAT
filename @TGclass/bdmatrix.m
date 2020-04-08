function bdmatrix(a,psat_obj)

psat_obj.LA.b_tg = [];  
psat_obj.LA.d_tg = [];  

if ~a.n
  psat_obj.fm_disp('* * * No turbine governor found')
  return
end

Fu = sparse(psat_obj.DAE.n,a.n);
Gu = sparse(a.wref,1:a.n,a.u,psat_obj.DAE.m,a.n);

% B & D matrix for reference speed
psat_obj.LA.d_tg = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_tg = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_tg);
