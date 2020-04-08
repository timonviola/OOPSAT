function values = highests(a,psat_obj)

values = [];

if ~a.n, return, end

n1 = psat_obj.DAE.n+psat_obj.DAE.m+2*psat_obj.Bus.n+6*psat_obj.Settings.nseries;
idx = find(psat_obj.Varname.idx > n1 & psat_obj.Varname.idx <= n1+a.n);

if isempty(idx), return, end

out = psat_obj.Varout.vars(:,idx);

for k = 1:length(idx)
  h = psat_obj.Varname.idx(idx(k)) - n1;
  if a.con(h,15)
    out(:,k) = out(:,k)/a.con(h,15);
  end
end

vals = max(out,[],1);
[y,jdx] = sort(vals,2,'descend');

if length(jdx) > 3, jdx = jdx(1:3); end

values = idx(jdx);
