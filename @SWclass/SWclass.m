function a = SWclass(psat_obj,varargin)
% constructor of the class SW
% == Swing generator ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.pg = [];
  a.store = [];
  a.qg = [];
  a.dq = [];
  a.qmax = [];
  a.qmin = [];
  a.u = [];
  a.refbus = [];
  a.ncol = 13;
  a.format = ['%4d ',repmat('%8.4g ',1,10),'%2u %2u'];
  if psat_obj.Settings.matlab, a = class(a,'SWclass'); end
 case 2
  if isa(varargin{1},'SWclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
