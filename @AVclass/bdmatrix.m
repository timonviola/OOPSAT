function bdmatrix(a,psat_obj)

psat_obj.LA.b_avr = [];  
psat_obj.LA.d_avr = [];  

if ~a.n
  psat_obj.fm_disp('* * * No automatic voltage control found')
  return
end

Fu = sparse(psat_obj.DAE.n,a.n);
Gu = sparse(a.vref,1:a.n,a.u,psat_obj.DAE.m,a.n);

% B & D matrix for Vref0
psat_obj.LA.d_avr = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_avr = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_avr);  
