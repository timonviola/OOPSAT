function bdmatrix(a,psat_obj)

psat_obj.LA.b_tcsc = [];  
psat_obj.LA.d_tcsc = [];  

if ~a.n
  psat_obj.fm_disp('* * * No TCSC device found')
  return
end

ty2 = find(a.con(:,3) == 2);  % Constant P control

ix = 1:2:2*a.n;   % index of X0 for any operation mode (X or P constant)
ip = 2:2:2*a.n;   % index of Pref for P constant operation mode
% ix = find(a.con(:,3) == 1); % index - operation mode x constant
% ip = find(a.con(:,3) == 2); % index - operation mode P constant

Fu = sparse(psat_obj.DAE.n,2*a.n);
Gu = sparse(a.x0,ix,a.u,psat_obj.DAE.m,2*a.n) + ...
    sparse(a.pref(ty2),ip(ty2),a.u(ty2),psat_obj.DAE.m,2*a.n);

% B & D matrix for TCSC references
psat_obj.LA.d_tcsc = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_tcsc = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_tcsc);  
