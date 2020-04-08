function a = dynidx(a,psat_obj)

if ~a.n, return, end

a.v = psat_obj.DAE.n+[1:a.n]';
a.If = psat_obj.DAE.m+[1:a.n]';
psat_obj.DAE.n = psat_obj.DAE.n + a.n;
psat_obj.DAE.m = psat_obj.DAE.m + a.n;

a.p = psat_obj.Syn.p(a.syn);
a.q = psat_obj.Syn.q(a.syn);
a.vref = psat_obj.Exc.vref(a.exc);
