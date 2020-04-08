function a = gcall(a,psat_obj)
if ~a.n, return, end

psat_obj.DAE.g = zeros(psat_obj.DAE.m,1);

na = psat_obj.Bus.a;
nv = psat_obj.Bus.v;

psat_obj.DAE.y(nv) = max(psat_obj.DAE.y(nv),1e-6);
Vc = psat_obj.DAE.y(nv).*exp(i*psat_obj.DAE.y(na));
S = Vc.*conj(a.Y*Vc);
a.p = real(S);
a.q = imag(S);

psat_obj.DAE.g(na) = a.p;
psat_obj.DAE.g(nv) = a.q;

