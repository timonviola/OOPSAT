function Fxcall(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);

if ~isempty(a.ty1)
  bcv = psat_obj.DAE.x(a.bcv);
  Tr = a.con(a.ty1,6);
  Kr = a.con(a.ty1,7);
  bcv_max = a.con(a.ty1,9);
  bcv_min = a.con(a.ty1,10);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.bcv,a.bcv,a.u(a.ty1)./Tr,psat_obj.DAE.n,psat_obj.DAE.n);
  u = bcv < bcv_max & bcv > bcv_min & a.u(a.ty1);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx + sparse(a.q(a.ty1),a.bcv,u.*V(a.ty1).^2,psat_obj.DAE.m,psat_obj.DAE.n);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy - sparse(a.bcv,a.vbus(a.ty1),u.*Kr./Tr,psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.bcv,a.vref(a.ty1),u.*Kr./Tr,psat_obj.DAE.n,psat_obj.DAE.m);
end

if ~isempty(a.ty2)
  alpha = psat_obj.DAE.x(a.alpha);
  vm = psat_obj.DAE.x(a.vm);
  a_max = a.con(a.ty2,9);
  a_min = a.con(a.ty2,10);
  T2 = a.con(a.ty2,6);
  K = a.con(a.ty2,7);
  Kd = a.con(a.ty2,11);
  T1 = a.con(a.ty2,12);
  Km = a.u(a.ty2).*a.con(a.ty2,13);
  Tm = a.con(a.ty2,14);
  xl = a.con(a.ty2,15);
  xc = a.con(a.ty2,16);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.vm,a.vm,a.u(a.ty2)./Tm,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.vm,a.vbus(a.ty2),Km./Tm,psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.alpha,a.alpha,a.u(a.ty2).*Kd./T2,psat_obj.DAE.n,psat_obj.DAE.n);
  u = alpha < a_max & alpha > a_min & a.u(a.ty2);
  k1 = -u.*K.*T1./T2./Tm.*Km;
  k2 = u.*K.*T1./T2./Tm - K./T2;
  k3 = -2*u.*V(a.ty2).*V(a.ty2).*(1-cos(2*alpha))./xl/pi;
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.alpha,a.vbus(a.ty2),k1,psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.alpha,a.vref(a.ty2),u.*K./T2,psat_obj.DAE.n,psat_obj.DAE.m);
  psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.alpha,a.vm,k2,psat_obj.DAE.n,psat_obj.DAE.n);
  psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.q(a.ty2),a.alpha,k3,psat_obj.DAE.m,psat_obj.DAE.n);
end
