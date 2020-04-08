function a = ELclass(psat_obj,varargin)
% constructor of the Exponential Recovery Load
% == Exponential Recovery Load ==
switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.dat = [];
  a.xp = [];
  a.xq = [];
  a.u = [];
  a.ncol = 11;
  a.format = ['%4d ',repmat('%8.4g ',1,9),'%2u'];
  a.store = [];
  if psat_obj.Settings.matlab, a = class(a,'ELclass'); end
 case 2
  if isa(varargin{1},'ELclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
