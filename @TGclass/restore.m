function a = restore(a,psat_obj)
% restores device properties as given in the data file
if isempty(a.store)
  a = init(a);
else
  a.con = a.store;
  a = setup(a,psat_obj);
end
