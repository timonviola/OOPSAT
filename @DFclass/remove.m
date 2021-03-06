function a = remove(a,idx)

if ~a.n, return, end
if isempty(idx), return, end

a.con(idx,:) = [];
a.bus(idx) = [];
a.vbus(idx) = [];
a.wind(idx) = [];
a.n = a.n - length(idx);
a.omega_m(idx) = [];
a.theta_p(idx) = [];
a.idr(idx) = [];
a.iqr(idx) = [];
a.vref(idx) = [];
a.pwa(idx) = [];
a.u(idx) = [];
