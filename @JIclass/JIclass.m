function a = JIclass(psat_obj,varargin)
% constructor of the Jimma Load
% == Jimma Load ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.dat = [];
  a.x = [];
  a.u = [];
  a.ncol = 13;
  a.format = ['%4d ',repmat('%8.4g ',1,11),'%2u'];
  a.store = [];
  if psat_obj.Settings.matlab, a = class(a,'JIclass'); end
 case 2
  if isa(varargin{1},'JIclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
