function a = move2sup(a,psat_obj)

if ~a.n, return, end


idx = find(a.u);
data = zeros(a.n,15);
data(:,[1 2 15]) = a.con(:,[1 2 11]);
data(:,3) = a.pg;
psat_obj.Supply = add(psat_obj.Supply,data(idx,:));
a.pg(idx) = 0;
