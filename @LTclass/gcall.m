function a = gcall(a,psat_obj)
if ~a.n, return, end

mmax  = a.con(:,9);
mmin  = a.con(:,10);
mstep = a.con(:,11);

mc = psat_obj.DAE.x(a.mc);
md = psat_obj.DAE.y(a.md);

% compute discrete tap ratio
idx = find(mstep);
for ii = 1:length(idx)
  jj = idx(ii);
  %seq = mmin(jj):mstep(jj):mmax(jj);
  %[val, jdx] = min(abs(seq-mc(jj)));
  %mval = seq(jdx);
  mval = mmin(jj) + mstep(jj)*round((mc(jj)-mmin(jj))/mstep(jj));
  psat_obj.DAE.g(a.md(jj)) = 0;
  if ~psat_obj.Settings.init
    psat_obj.DAE.y(a.md(jj)) = mval;
    a.mold(jj) = mval;
    mc(jj) = mval;
    md(jj) = mval;
  else
    %if mval ~= a.mold(jj) & psat_obj.DAE.t-a.delay(jj) > 0.333/a.con(jj,8)
    if abs(mc(jj)-mval) < (0.5-a.con(jj,17)/100)*mstep(jj)
      a.delay(jj) = psat_obj.DAE.t;
      a.mold(jj) = mval;
      psat_obj.DAE.y(a.md(jj)) = mval;
      mc(jj) = mval;
      md(jj) = mval;
    else
      psat_obj.DAE.y(a.md(jj)) = a.mold(jj);
      mc(jj) = a.mold(jj);
      md(jj) = a.mold(jj);
    end
  end
end

psat_obj.DAE.g = psat_obj.DAE.g + sparse(a.md, 1, a.u.*(mc-md), psat_obj.DAE.m, 1);

Vf = a.u.*psat_obj.DAE.y(a.v1).*exp(i*psat_obj.DAE.y(a.bus1));
Vt = a.u.*psat_obj.DAE.y(a.v2).*exp(i*psat_obj.DAE.y(a.bus2));  
y = admittance(a);

Ss = Vf.*conj((Vf./md-Vt).*y./md);
Sr = Vt.*conj((Vt-Vf./md).*y);

psat_obj.DAE.g = psat_obj.DAE.g ...
        + sparse(a.bus1, 1, real(Ss), psat_obj.DAE.m, 1) ...
        + sparse(a.bus2, 1, real(Sr), psat_obj.DAE.m, 1) ...
        + sparse(a.v1,   1, imag(Ss), psat_obj.DAE.m, 1) ...
        + sparse(a.v2,   1, imag(Sr), psat_obj.DAE.m, 1);
      
for ii = 1:length(idx)
  jj = idx(ii);
  ms = mstep(jj);
  if abs(psat_obj.DAE.g(a.bus1(jj))) < ms, psat_obj.DAE.g(a.bus1(jj)) = 0; end
  if abs(psat_obj.DAE.g(a.bus2(jj))) < ms, psat_obj.DAE.g(a.bus2(jj)) = 0; end
  if abs(psat_obj.DAE.g(a.v1(jj))) < ms, psat_obj.DAE.g(a.v1(jj)) = 0; end
  if abs(psat_obj.DAE.g(a.v2(jj))) < ms, psat_obj.DAE.g(a.v2(jj)) = 0; end
end

