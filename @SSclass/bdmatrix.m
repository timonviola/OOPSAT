function bdmatrix(a,psat_obj)

psat_obj.LA.b_sssc = [];  
psat_obj.LA.d_sssc = [];  

if ~a.n
  psat_obj.fm_disp('* * * No SSSC device found')
  return
end


ty3 = find(a.con(:,2) == 3);  % Constant P control

iv = 1:2:2*a.n;   % index of V0 for any operation mode (V,X, or P constant)
ip = 2:2:2*a.n;   % index of Pref for P constant operation mode

Fu = sparse(psat_obj.DAE.n,2*a.n);
Gu = sparse(a.v0,iv,a.u,psat_obj.DAE.m,2*a.n) + ...
     sparse(a.pref(ty3),ip(ty3),a.u(ty3),psat_obj.DAE.m,2*a.n);  

% B & D matrix for SSSC references
psat_obj.LA.d_sssc = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_sssc = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_sssc);