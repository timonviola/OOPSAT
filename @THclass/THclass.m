function a = THclass(psat_obj,varargin)
% constructor of the Thermostatically Controlled Load
% == Thermostatically Controlled Load ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.T = [];
  a.G = [];
  a.x = [];
  a.u = [];
  a.ncol = 12;
  a.format = ['%4d ',repmat('%8.4g ',1,10),'%2u'];
  a.store = [];
  if psat_obj.Settings.matlab, a = class(a,'THclass'); end
 case 2
  if isa(varargin{1},'THclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
