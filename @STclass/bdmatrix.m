function bdmatrix(a,psat_obj)


psat_obj.LA.b_statcom = [];  
psat_obj.LA.d_statcom = [];  

if ~a.n
  psat_obj.fm_disp('* * * No Statcom device found')
  return
end

Fu = sparse(psat_obj.DAE.n,a.n);
Gu = sparse(a.vref,1:a.n,a.u,psat_obj.DAE.m,a.n);

% B & D matrix for reference voltage
psat_obj.LA.d_statcom = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_statcom = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_statcom);  

