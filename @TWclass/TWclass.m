function a = TWclass(psat_obj,varargin)
% constructor of the class Three Winding Transformer
% == Three Winding Transformer ==
switch nargin
 case 1
  a.con = [];
  a.store = [];
  a.ncol = 25;
  a.format = ['%4d %4d %4d ',repmat('%8.4g ',1,21),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'TWclass'); end
 case 2
  if isa(varargin{1},'TWclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
