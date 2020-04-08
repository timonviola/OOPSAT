function a = setstatus(a,idx,u,psat_obj)

if ~a.n, return, end
if isempty(idx), return, end

a.u(idx) = u; 
a = build_y(a,psat_obj);
islands(a)
