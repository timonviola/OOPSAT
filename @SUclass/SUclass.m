function a = SUclass(psat_obj,varargin)
% constructor of the class Supply
% == Supply ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.store = [];
  a.ncol = 20;
  a.u = [];
  a.format = ['%4d ',repmat('%8.4g ',1,11),'%2u ', repmat('%8.4g ',1,6),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'SUclass'); end
 case 2
  if isa(varargin{1},'SUclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
