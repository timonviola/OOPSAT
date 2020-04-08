function a = MNclass(psat_obj,varargin)
% constructor of the Monomila Load
% == Monomial Load ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.init = [];
  a.u = [];
  a.store = [];
  a.ncol = 9;
  a.format = ['%4d ',repmat('%8.4g ',1,6),'%2u %2u'];
  if psat_obj.Settings.matlab, a = class(a,'MNclass'); end
 case 2
  if isa(varargin{1},'MNclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
