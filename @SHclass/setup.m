function a = setup(a,psat_obj,varargin)

switch nargin-1
 case 2
  psat_obj.Bus = varargin{1};
 otherwise
  %global Bus
end

if isempty(a.con)
  a.store = [];
  return
end

a.n = length(a.con(:,1));
[a.bus,a.vbus] = getbus(psat_obj.Bus,a.con(:,1));

if length(a.con(1,:)) < a.ncol
  a.u = ones(a.n,1);
else
  a.u = a.con(:,a.ncol);
end

a.store = a.con;

