function gcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.g = psat_obj.DAE.g ...
        - sparse(a.vbus,1,a.u.*psat_obj.DAE.x(a.ist).*psat_obj.DAE.y(a.vbus),psat_obj.DAE.m,1) ...
        + sparse(a.vref,1,a.Vref-psat_obj.DAE.y(a.vref),psat_obj.DAE.m,1);
