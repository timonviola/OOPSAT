function a = SVclass(psat_obj,varargin)
% constructor of the class SVC
% == SVC ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.ty1 = [];
  a.ty2 = [];
  a.store = [];
  a.Be = [];
  a.vm = [];
  a.bcv = [];
  a.alpha = [];
  a.vref = [];
  a.q = [];
  a.u = [];
  a.ncol = 17;
  a.format = ['%4d %8.4g %8.4g %8.4g %4d ',repmat('%8.4g ',1,11),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'SVclass'); end
 case 2
  if isa(varargin{1},'SVclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
