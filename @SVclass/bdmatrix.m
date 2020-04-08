function bdmatrix(a,psat_obj)

psat_obj.LA.b_svc = [];  
psat_obj.LA.d_svc = [];  

if ~a.n
  psat_obj.fm_disp('* * * No SVC device found')
  return
end

Fu = sparse(psat_obj.DAE.n,a.n);
Gu = sparse(a.vref,1:a.n,a.u,psat_obj.DAE.m,a.n);

% B & D matrix for reference voltage
psat_obj.LA.d_svc = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_svc = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_svc);  

