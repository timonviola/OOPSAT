function a = UPclass(psat_obj,varargin)
% constructor of the class UPFC
% == UPFC ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus1 = [];
  a.bus2 = [];
  a.v1 = [];
  a.v2 = [];
  a.line = [];
  a.vp = [];
  a.vq = [];
  a.iq = [];
  a.store = [];
  a.xcs = [];
  a.Cp = [];
  a.gamma = [];
  a.vp0 = [];
  a.vq0 = [];
  a.vref = [];
  a.Vp0 = [];
  a.Vq0 = [];
  a.Vref = [];
  a.y = [];
  a.u = [];
  a.ncol = 18;
  a.format = ['%4d %4d ',repmat('%8.4g ',1,12),'%4d %4d %4d %2u'];
  if psat_obj.Settings.matlab, a = class(a,'UPclass'); end
 case 2
  if isa(varargin{1},'UPclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
