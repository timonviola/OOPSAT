function a = PVclass(psat_obj,varargin)
% constructor of the class PV
% == PV generator ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.pq = [];
  a.qg = [];
  a.u = [];
  a.store = [];
  a.qmax = [];
  a.qmin = [];
  a.newpq = 0;
  a.ncol = 11;
  a.format = ['%4d ',repmat('%8.4g ',1,9),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'PVclass'); end
 case 2
  if isa(varargin{1},'PVclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
