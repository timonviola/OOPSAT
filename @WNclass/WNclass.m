function a = WNclass(psat_obj,varargin)
% constructor of the class Wind
% == Wind ==
switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.speed = struct('vw',[],'time',[]);
  a.vwa = [];
  a.vw = [];
  a.ws = [];
  a.store = [];
  a.ncol = 17;
  a.format = ['%4d ',repmat('%8.4g ',1,15), '%4d'];
  if psat_obj.Settings.matlab, a = class(a,'WNclass'); end
 case 2
  if isa(varargin{1},'WNclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
