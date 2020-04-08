function a = PSclass(psat_obj,varargin)
% constructor of the class Power System Stabilizer
% == Pss ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.syn = [];
  a.exc = [];
  a.store = [];
  a.va = [];
  a.v1 = [];
  a.v2 = [];
  a.v3 = [];
  a.vss = [];
  a.omega = [];
  a.p = [];
  a.vf = [];
  a.vref = [];
  a.s1 = [];
  a.u = [];
  a.ncol = 23;
  a.format = ['%4d %4d %4d ',repmat('%8.4g ',1,18),'%2u %2u'];
  if psat_obj.Settings.matlab, a = class(a,'PSclass'); end
 case 2
  if isa(varargin{1},'PSclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
