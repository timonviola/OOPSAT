function a = PQclass(psat_obj,varargin)
% constructor of the class PQ
% == PQ load ==

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.gen = [];
  a.store = [];
  a.P0 = [];
  a.Q0 = [];
  a.vmax = [];
  a.vmin = [];
  a.ncol = 9;
  a.shunt = [];
  a.u = [];
  a.format = ['%4d ',repmat('%8.4g ',1,6),'%2u %2u'];
  if psat_obj.Settings.matlab, a = class(a,'PQclass'); end
 case 2
  if isa(varargin{1},'PQclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
