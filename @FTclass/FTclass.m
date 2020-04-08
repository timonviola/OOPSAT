function a = FTclass(psat_obj,varargin)
% constructor of the class Fault
% == Fault ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.dat = [];
  a.time = inf;
  a.u = [];
  a.store = [];
  a.ncol = 8;
  a.format = ['%4d ',repmat('%8.4g ',1,7)];
  if psat_obj.Settings.matlab, a = class(a,'FTclass'); end
 case 2
  if isa(varargin{1},'FTclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
