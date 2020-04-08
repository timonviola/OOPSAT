function den = ssscden(a,psat_obj)

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
cc = cos(psat_obj.DAE.y(a.bus1)-psat_obj.DAE.y(a.bus2));

den = max(sqrt(V1.^2+V2.^2-2.*V1.*V2.*cc),1e-6*ones(a.n,1));
