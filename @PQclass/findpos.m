function idx = findpos(a,psat_obj)


idx = [];
if ~a.n, return, end

if psat_obj.CPF.onlypqgen
  idx = find(a.u & a.gen);
  if isempty(idx)
    psat_obj.fm_disp('No PQ generator found. Expect meaningless results.')
  end
elseif psat_obj.CPF.onlynegload
  idx = find(a.u.*a.con(:,4) < 0);
  if isempty(idx)
    psat_obj.fm_disp('No negative load found. Expect meaningless results.')
  end
elseif psat_obj.CPF.negload
  idx = find(a.u);
else
  idx = find(a.u.*a.con(:,4) >= 0);
end

