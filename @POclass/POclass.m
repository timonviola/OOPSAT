function a = POclass(psat_obj,varargin)
% constructor of the class Power Oscillation Damper
% == POD ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.svc = [];
  a.statcom = [];
  a.sssc = [];
  a.tcsc = [];
  a.upfc = [];
  a.dfig = [];
  a.idx = [];
  a.type = [];
  a.v1 = [];
  a.v2 = [];
  a.v3 = [];
  a.Vs = [];
  a.kr = [];
  a.z = [];
  a.u = [];
  a.store = [];
  a.ncol = 14;
  a.format = ['%4d %4d %4d %4d ',repmat('%8.4g ',1,9),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'POclass'); end
 case 2
  if isa(varargin{1},'POclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
