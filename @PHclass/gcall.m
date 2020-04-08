function gcall(a,psat_obj)

if ~a.n, return, end

Vf = a.u.*psat_obj.DAE.y(a.v1).*exp(i*psat_obj.DAE.y(a.bus1));
Vt = a.u.*psat_obj.DAE.y(a.v2).*exp(i*psat_obj.DAE.y(a.bus2));  
y = admittance(a);
m = a.con(:,15).*exp(i*psat_obj.DAE.x(a.alpha));

Ss = Vf.*conj((Vf./m-Vt).*y./conj(m));
Sr = Vt.*conj((Vt-Vf./m).*y);

psat_obj.DAE.g = psat_obj.DAE.g + ...
        sparse(a.bus1,1,real(Ss),psat_obj.DAE.m,1) + ...
        sparse(a.bus2,1,real(Sr),psat_obj.DAE.m,1) + ...
        sparse(a.v1,1,imag(Ss),psat_obj.DAE.m,1) + ...
        sparse(a.v2,1,imag(Sr),psat_obj.DAE.m,1);
