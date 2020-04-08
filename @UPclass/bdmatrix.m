function bdmatrix(a,psat_obj)

psat_obj.LA.b_upfc = [];  
psat_obj.LA.d_upfc = [];  

if ~a.n
  psat_obj.fm_disp('* * * No UPFC device found')
  return
end

ivp = 1:3:3*a.n;
ivq = 2:3:3*a.n;
ivr = 3:3:3*a.n;

ty2 = find(a.con(:,2) == 1); % constant voltage control

Fu = sparse(psat_obj.DAE.n,3*a.n);
Gu = sparse(a.vp0,ivp,a.u,psat_obj.DAE.m,3*a.n) + ...
     sparse(a.vq0(ty2),ivq(ty2),a.u(ty2),psat_obj.DAE.m,3*a.n) + ...
     sparse(a.vref,ivr,a.u,psat_obj.DAE.m,3*a.n);

% B & D matrix for UPFC references
psat_obj.LA.d_upfc = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_upfc = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_upfc);  

