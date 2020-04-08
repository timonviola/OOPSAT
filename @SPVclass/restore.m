function a = restore(a,psat_obj)

if isempty(a.store)
  a = init(a);
else
  a.con = a.store;
  a = setup(a,psat_obj);
end
