function a = move2sup(a,idx,psat_obj)

if ~a.n, return, end

if isempty(idx), return, end

data = zeros(length(idx),15);
data(:,[1 2 3 15]) = a.con(idx,[1 2 4 10]);
psat_obj.Supply = add(psat_obj.Supply,data);

a = remove(a,idx);
