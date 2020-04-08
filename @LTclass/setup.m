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
[a.bus1,a.v1] = getbus(psat_obj.Bus,a.con(:,1));
[a.bus2,a.v2] = getbus(psat_obj.Bus,a.con(:,2));

% fix data for backward compatibility
if length(a.con(1,:)) < 17
  a.con = [a.con, 0.5*ones(a.n, 1)];
  a.u = ones(a.n,1);
elseif length(a.con(1,:)) == 17
  a.u = a.con(:,17);
  a.con(:,17) = 0.5*ones(a.n, 1);
else
  a.u = a.con(:,a.ncol);
end

a.delay = psat_obj.Settings.t0*ones(a.n,1);
a.mold = ones(a.n,1);
a.store = a.con;

% fix remote control bus number
a.vr = a.v2;
idx = find(a.con(:,16) == 3);
if ~isempty(idx)
  a.vr(idx) = getvint(psat_obj.Bus,a.con(idx,15));
end

% fix nominal tap ratio
idx = find(a.con(:,6) == 0);
if ~isempty(idx)
  a.con(idx,6) = 1;
end

psat_obj.Settings.nseries = psat_obj.Settings.nseries + a.n;
