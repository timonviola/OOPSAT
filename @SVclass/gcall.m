function gcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
B = a.u.*bsvc(a);

psat_obj.DAE.g = psat_obj.DAE.g ...
        - sparse(a.vbus,1,psat_obj.DAE.y(a.q),psat_obj.DAE.m,1) ...
        + sparse(a.q,1,B.*V.*V-psat_obj.DAE.y(a.q),psat_obj.DAE.m,1) ...
        + sparse(a.vref,1,a.con(:,8)-psat_obj.DAE.y(a.vref),psat_obj.DAE.m,1);
