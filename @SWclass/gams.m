function [n,idx,data] = gams(a,psat_obj)


n = int2str(a.n);
idx = sparse(a.bus,[1:a.n],1,psat_obj.Bus.n,a.n);
data = getzeros(psat_obj.Bus);
if a.n
  data(a.bus) = a.u.*a.con(:,11);
end
