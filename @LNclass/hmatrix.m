function hmatrix(a,psat_obj)
if ~a.n
  psat_obj.LA.h_ps = [];  
  psat_obj.LA.h_qs = [];  
  psat_obj.LA.h_is = [];  
  psat_obj.LA.h_pr = [];  
  psat_obj.LA.h_qr = [];  
  psat_obj.LA.h_ir = [];  
  psat_obj.fm_disp('No transmission line or transformer found')
  return
end

unos = ones(a.n,2*psat_obj.Bus.n);

[Iij,JIij,Iji,JIji] = fjh2(a,1,psat_obj);
[Pij,JPij,Pji,JPji] = fjh2(a,2,psat_obj);
[Sij,JSij,Sji,JSji] = fjh2(a,3,psat_obj);
[FPij,FQij,FPji,FQji] = flows(a,psat_obj,'pq');

JIs = 0.5*JIij./(diag(sqrt(Iij))*unos);
JIr = 0.5*JIji./(diag(sqrt(Iji))*unos);
JPs = 0.5*JPij./(diag(sqrt(Pij).*sign(FPij))*unos);
JPr = 0.5*JPji./(diag(sqrt(Pji).*sign(FPji))*unos);
JQs = 0.5*(JSij-JPij)./(diag(sqrt(Sij-Pij).*sign(FQij))*unos);
JQr = 0.5*(JSji-JPji)./(diag(sqrt(Sji-Pji).*sign(FQji))*unos);

[i,j,s] = find(JIs);
psat_obj.LA.h_is = full(sparse(i,j,s,a.n,psat_obj.DAE.m));

[i,j,s] = find(JIr);
psat_obj.LA.h_ir = full(sparse(i,j,s,a.n,psat_obj.DAE.m));

[i,j,s] = find(JPs);
psat_obj.LA.h_ps = full(sparse(i,j,s,a.n,psat_obj.DAE.m));

[i,j,s] = find(JPr);
psat_obj.LA.h_pr = full(sparse(i,j,s,a.n,psat_obj.DAE.m));

[i,j,s] = find(JQs);
psat_obj.LA.h_qs = full(sparse(i,j,s,a.n,psat_obj.DAE.m));

[i,j,s] = find(JQr);
psat_obj.LA.h_qr = full(sparse(i,j,s,a.n,psat_obj.DAE.m));
