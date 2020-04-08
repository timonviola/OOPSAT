function a = YPclass(psat_obj,varargin)
% constructor of the class Ypdp
% == Yearly Demand Profile ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.day = [];
  a.week = [];
  a.year = [];
  a.n = 0;
  a.d = 1;
  a.w = 1;
  a.y = 1;
  a.len = 0;
  a.store = [];
  a.ncol = 206;
  a.format = repmat('%5.2f ',1,206);
  if psat_obj.Settings.matlab, a = class(a,'YPclass'); end
 case 2
  if isa(varargin{1},'YPclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
