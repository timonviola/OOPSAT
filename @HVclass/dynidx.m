function a = dynidx(a,psat_obj)
if ~a.n, return, end

a.Idc = zeros(a.n,1);
a.xr = zeros(a.n,1);
a.xi = zeros(a.n,1);

a.cosa = zeros(a.n,1);  
a.cosg = zeros(a.n,1); 
a.phir = zeros(a.n,1);  
a.phii = zeros(a.n,1);
a.Vrdc = zeros(a.n,1);
a.Vidc = zeros(a.n,1);
a.yr = zeros(a.n,1);   
a.yi = zeros(a.n,1);

for i = 1:a.n

  a.Idc(i) = psat_obj.DAE.n + 1;
  a.xr(i) = psat_obj.DAE.n + 2;
  a.xi(i) = psat_obj.DAE.n + 3;
  
  psat_obj.DAE.n = psat_obj.DAE.n + 3;

  a.cosa(i) = psat_obj.DAE.m + 1;  
  a.cosg(i) = psat_obj.DAE.m + 2; 
  a.phir(i) = psat_obj.DAE.m + 3;  
  a.phii(i) = psat_obj.DAE.m + 4;
  a.Vrdc(i) = psat_obj.DAE.m + 5;
  a.Vidc(i) = psat_obj.DAE.m + 6;
  a.yr(i) = psat_obj.DAE.m + 7;   
  a.yi(i) = psat_obj.DAE.m + 8; 
  
  psat_obj.DAE.m = psat_obj.DAE.m + 8;
  
end

% extend the vector of algebraic variables 
psat_obj.DAE.y = [psat_obj.DAE.y; zeros(8*a.n,1)];
