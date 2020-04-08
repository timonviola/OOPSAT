function a = restore(a,psat_obj,varargin)

if isempty(a.store)
  a = init(a);
  return
end

a.con = a.store;
a = setup(a);

switch nargin-1
 case 2
  addpqgen = varargin{1};
 otherwise
  addpqgen = 1;
end

if psat_obj.PQgen.n && addpqgen
  a = addgen(a,psat_obj.PQgen);
end
