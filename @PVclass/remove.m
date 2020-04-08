function a = remove(a,k,psat_obj)

if ~a.n, return, end

if isempty(k), return, end
if ~isempty(psat_obj.DAE.Gk)
  psat_obj.DAE.Gk(a.bus(k)) = 0;
end
a.con(k,:) = [];
a.bus(k) = [];
a.vbus(k) = [];
a.u(k) = [];
a.pq(k) = [];
a.qg(k) = [];
a.n = a.n - length(k);
a.qmax(k) = [];
a.qmin(k) = [];
