function a = FLclass(psat_obj,varargin)
% constructor of the Frequency Dependent Load
% == Frequency Dependent Load ==


switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.a0 = [];
  a.dw = [];
  a.x = [];
  a.u = [];
  a.ncol = 9;
  a.format = ['%4d ',repmat('%8.4g ',1,7),'%2u'];
  a.store = [];
  if psat_obj.Settings.matlab, a = class(a,'FLclass'); end
 case 2
  if isa(varargin{1},'FLclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
