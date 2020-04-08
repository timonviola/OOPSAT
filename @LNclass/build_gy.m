function Gy = build_gy(a,psat_obj)

Gy = 1e-6*speye(psat_obj.DAE.m,psat_obj.DAE.m);
nb = psat_obj.Bus.n;

if ~a.n, return, end

n1 = psat_obj.Bus.a;
U = exp(i*psat_obj.DAE.y(n1));
V = psat_obj.DAE.y(psat_obj.Bus.v).*U;
I = a.Y*V;

diagVc = sparse(n1,n1,V,nb,nb);
diagVn = sparse(n1,n1,U,nb,nb);
diagIc = sparse(n1,n1,I,nb,nb);
dS = diagVc * conj(a.Y * diagVn) + conj(diagIc) * diagVn;
dR = conj(diagVc) * (diagIc - a.Y * diagVc);

[h,k,s] = find([imag(dR),real(dS);real(dR),imag(dS)]);
Gy = sparse(h,k,s,psat_obj.DAE.m,psat_obj.DAE.m);


