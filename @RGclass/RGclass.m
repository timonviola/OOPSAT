function a = RGclass(psat_obj,varargin)
% constructor of the class Rmpg
% == Generator Ramp ==
switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.sup = [];
  a.u = [];
  a.store = [];
  a.ncol = 10;
  a.format = '%4d %8.4g %8.4g %8.4g %4d %4d %4d %4d %8.4g %2u';
  if psat_obj.Settings.matlab, a = class(a,'RGclass'); end
 case 2
  if isa(varargin{1},'RGclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
