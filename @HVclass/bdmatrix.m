function bdmatrix(a,psat_obj)

psat_obj.LA.b_hvdc = [];  
psat_obj.LA.d_hvdc = [];  

if ~a.n
  psat_obj.fm_disp('* * * No HVDC device found')
  return
end

iyr = 1:2:2*a.n;
iyi = 2:2:2*a.n;

uI = a.u.*a.dat(:,9);
uP = a.u.*a.dat(:,10);
uV = a.u.*a.dat(:,11);

Vrdc = a.u.*psat_obj.DAE.y(a.Vrdc);
Vidc = a.u.*psat_obj.DAE.y(a.Vidc);

Fu = sparse(psat_obj.DAE.n,2*a.n);
Gu = sparse(a.yr,iyr,uI+uV+uP./(~a.u+Vrdc),psat_obj.DAE.m,2*a.n) + ...
     sparse(a.yi,iyi,uI+uV+uP./(~a.u+Vidc),psat_obj.DAE.m,2*a.n);

% B & D matrix for HVDC references
psat_obj.LA.d_hvdc = -full(psat_obj.DAE.Gy\Gu);
psat_obj.LA.b_hvdc = full(Fu + psat_obj.DAE.Fy*psat_obj.LA.d_hvdc);  

