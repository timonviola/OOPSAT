function a = dynidx(a,psat_obj)
if ~a.n, return, end

a.Vs = psat_obj.DAE.n + [1:a.n]';
psat_obj.DAE.n = psat_obj.DAE.n + a.n;

a.vref = zeros(a.n,1);
a.vref(a.psat_obj.Exc) = psat_obj.Exc.vref(a.con(a.psat_obj.Exc,2));
a.vref(a.psat_obj.Svc) = psat_obj.Svc.vref(a.con(a.psat_obj.Svc,2));

a.psat_obj.Cac = psat_obj.Cac.q(a.con(:,1));

a.q = zeros(a.n,1);
a.q(a.psat_obj.Exc) = psat_obj.Syn.q(a.psat_obj.Syn);
a.q(a.psat_obj.Svc) = psat_obj.Svc.q(a.con(a.psat_obj.Svc,2));

