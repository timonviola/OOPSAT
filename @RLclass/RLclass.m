function a = RLclass(psat_obj,varargin)
% constructor of the class Rmpl
% == Load Ramp ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.dem = [];
  a.u = [];
  a.store = [];
  a.ncol = 9;
  a.format = ['%4d ',repmat('%8.4g ',1,7),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'RLclass'); end
 case 2
  if isa(varargin{1},'RLclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
