function gcall(a,psat_obj)

if ~a.n, return, end

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
a1 = psat_obj.DAE.y(a.bus1);
a2 = psat_obj.DAE.y(a.bus2);
ss = sin(a1-a2);
cc = cos(a1-a2);

c1 = a.u.*psat_obj.DAE.x(a.vcs).*a.y./ssscden(a);  
P1 = c1.*V1.*V2.*ss;  
Q1 = c1.*(V1.^2-V1.*V2.*cc);
Q2 = c1.*(V2.^2-V1.*V2.*cc);

ty2 = find(a.con(:,2) == 2);
ty3 = find(a.con(:,2) == 3);

V0 = a.V0;

if ty2
  den = ssscden(a);
  kp = a.Cp(ty2)./(1-a.Cp(ty2));
  V0(ty2) = kp.*den(ty2);
end

if ty3   
  global Line
  [Ps,Qs,Pr,Qr] = flows(Line,psat_obj,'pq',a.line);
  [Ps,Qs,Pr,Qr] = flows(a,psat_obj,Ps,Qs,Pr,Qr,'sssc');
  Kpr = a.con(:,11);
  tp = ty3(find(a.con(ty3,10) == 1));
  ta = ty3(find(a.con(ty3,10) == 2));    
  if tp
    V0(tp) = Kpr(tp).*(psat_obj.DAE.y(a.pref(tp))-Ps(tp)) + psat_obj.DAE.x(a.vpi(tp));
  end
  if ta
    V0(ta) = Kpr(ta).*(psat_obj.DAE.y(a.pref(ta))-Ps(ta)-Pr(ta)) + psat_obj.DAE.x(a.vpi(ta));
  end
end

psat_obj.DAE.g = psat_obj.DAE.g ...
        + sparse(a.bus1,1,P1,psat_obj.DAE.m,1) ...
        - sparse(a.bus2,1,P1,psat_obj.DAE.m,1) ...
        + sparse(a.v1,1,Q1,psat_obj.DAE.m,1) ...
        + sparse(a.v2,1,Q2,psat_obj.DAE.m,1) ...
        + sparse(a.v0,1,V0-psat_obj.DAE.y(a.v0),psat_obj.DAE.m,1) ...
        + sparse(a.pref,1,a.Pref-psat_obj.DAE.y(a.pref),psat_obj.DAE.m,1); 
