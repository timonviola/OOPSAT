function a = VLclass(psat_obj,varargin)
% constructor of the class Vltn
% == Generator Violations ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.sup = [];
  a.u = [];
  a.store = [];
  a.ncol = 10;
  a.format = ['%4d ',repmat('%8.4g ',1,8),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'VLclass'); end
 case 2
  if isa(varargin{1},'VLclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
