function a = base(a,psat_obj)

if ~a.n, return, end

% reset generator parameters
a.M = getvar(psat_obj.Syn,a.gen,'M');
for i = 1:a.n
  idx = a.syn{i};
  a.Mtot(i,1) = sum(a.M(idx));
end


