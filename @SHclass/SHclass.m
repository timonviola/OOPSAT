function a = SHclass(psat_obj,varargin)
% constructor of the class Shunt
% == Shunt ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.u = [];
  a.store = [];
  a.ncol = 7;
  a.format = ['%4d ',repmat('%8.4g ',1,5),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'SHclass'); end
 case 2
  if isa(varargin{1},'SHclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
