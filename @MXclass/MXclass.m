function a = MXclass(psat_obj,varargin)
% constructor of the Mixed Load
% == Mixed Load ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.dat = [];
  a.x = [];
  a.y = [];
  a.u = [];
  a.ncol = 15;
  a.format = ['%4d ',repmat('%8.4g ',1,13),'%2u'];
  a.store = [];
  if psat_obj.Settings.matlab, a = class(a,'MXclass'); end
 case 2
  if isa(varargin{1},'MXclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
