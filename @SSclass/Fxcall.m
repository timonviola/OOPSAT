function Fxcall(p,psat_obj)

if ~p.n, return, end

V1 = psat_obj.DAE.y(p.v1);
V2 = psat_obj.DAE.y(p.v2);
a1 = psat_obj.DAE.y(p.bus1);
a2 = psat_obj.DAE.y(p.bus2);
ss = sin(a1-a2);
cc = cos(a1-a2);
den = ssscden(p);
kp = p.Cp./(1-p.Cp);
vcs = psat_obj.DAE.x(p.vcs);
Tr = p.con(:,7);
vcs_max = p.con(:,8);
vcs_min = p.con(:,9);

Ms = p.y./den;

P1vs = Ms.*V1.*V2.*ss;  
P2vs = -P1vs;
Q1vs = Ms.*V1.*(V1-V2.*cc);
Q2vs = Ms.*V2.*(V2-V1.*cc);

u = vcs < vcs_max & vcs > vcs_min & p.u;
ty3 = p.con(:,2) == 3;

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.vcs,p.vcs,1./Tr,psat_obj.DAE.n,psat_obj.DAE.n);
if ~isempty(find(ty3))
  id3 = find(ty3);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.vpi(id3),p.vpi(id3),~p.u(id3),psat_obj.DAE.n,psat_obj.DAE.n);
end

psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.vcs,p.v0,u./Tr,psat_obj.DAE.n,psat_obj.DAE.m);

psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.bus1,p.vcs,u.*P1vs,psat_obj.DAE.m,psat_obj.DAE.n);  
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.bus2,p.vcs,u.*P2vs,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.v1,p.vcs,u.*Q1vs,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.v2,p.vcs,u.*Q2vs,psat_obj.DAE.m,psat_obj.DAE.n);    

a = find(p.u.*u.*ty3);
if a
  
  c = find(p.con(a,10) ~= 2);
  b = a(c);
  Kpr = p.con(a,11);
  Kin = p.con(a,12);
  c1 = p.y(a).*(1+vcs(a)./den(a));
  c2 = p.y(a).*vcs(a)./(den(a).^3);    
  Ms = p.y(a)./den(a);
  M2 = c2.*V1(a).*V2(a).*ss(a);
  M1 = -M2;
  M3 = c2.*(V2(a).*cc(a)-V1(a));
  M4 = c2.*(V1(a).*cc(a)-V2(a));              
  Jps1 = V1(a).*V2(a).*(M1.*ss(a)+c1.*cc(a));
  Jps2 = V1(a).*V2(a).*(M2.*ss(a)-c1.*cc(a));
  Jps3 = V2(a).*ss(a).*(M3.*V1(a)+c1);
  Jps4 = V1(a).*ss(a).*(M4.*V2(a)+c1);
  Jps5 = Ms.*V1(a).*V2(a).*ss(a);

  psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(p.v0(b),p.vcs(b),Jps5(c).*Kpr(b),psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(p.v0(a),p.vpi(a),1,psat_obj.DAE.m,psat_obj.DAE.n);

  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(p.vpi(b),p.vcs(b),Jps5(c).*Kin(b),psat_obj.DAE.n,psat_obj.DAE.n);
  
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(p.vpi(a),p.pref(a),Kin(a),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(p.vpi(b),p.bus1(b),Jps1(c).*Kin(b),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(p.vpi(b),p.bus2(b),Jps2(c).*Kin(b),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(p.vpi(b),p.v1(b),Jps3(c).*Kin(b),psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(p.vpi(b),p.v2(b),Jps4(c).*Kin(b),psat_obj.DAE.n,psat_obj.DAE.m);
  
end    
