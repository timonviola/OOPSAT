function a = add(psat_obj,a,data,varargin)

switch nargin-1
 case 3
  psat_obj.Bus = varargin{1};
 otherwise
 % global psat_obj.Bus
end

if isempty(data), return, end

% check data size
[nrow,ncol] = size(data);
if ncol < a.ncol
  data = [data, zeros(nrow,a.ncol-ncol)];
  if ncol < a.nu
    data(:,a.nu) = ones(nrow,1);
  end
elseif ncol > a.ncol
  data = data(:,[1:a.ncol]);
end

a.n = a.n + nrow;
a.con = [a.con; data];
a.u = [a.u; data(:,a.nu)];
[a.fr,a.vfr] = getbus(psat_obj.Bus,a.con(:,1));
[a.to,a.vto] = getbus(psat_obj.Bus,a.con(:,2));

psat_obj.Settings.nseries = psat_obj.Settings.nseries + nrow;
