function a = OXclass(psat_obj,varargin)
% constructor of the class Over Excitation Limiter
% == OXL ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.syn = [];
  a.bus = [];
  a.vbus = [];
  a.exc = [];
  a.v = [];
  a.p = [];
  a.q = [];
  a.vref = [];
  a.If = [];
  a.u = [];
  a.store = [];
  a.ncol = 8;
  a.format = '%4d %8.4g %4d %8.4g %8.4g %8.4g %8.4g %2u';
  if psat_obj.Settings.matlab, a = class(a,'OXclass'); end
 case 2
  if isa(varargin{1},'OXclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
