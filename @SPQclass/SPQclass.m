function a = SPQclass(psat_obj,varargin)
% constructor of the class Solar Photo-Voltaic Generator
% == SPVG ==
% Constant P & Constant Q
% Developed by Behnam Tamimi <btamimi@ieee.org>
% December, 2009

switch nargin
 case 1
  a.con = [];
  a.n = 0;
  a.bus = [];
  a.vbus = [];
  a.id = [];
  a.iq = [];
  a.store = [];
  a.u = [];
  a.ncol = 6;
  a.format = ['%4d ',repmat('%8.4g ',1,4),'%2u'];
  if psat_obj.Settings.matlab, a = class(a,'SPQclass'); end
 case 2
  if isa(varargin{1},'SPQclass')
    a = varargin{1};
  else
    error('Wrong argument type')
  end
 otherwise
  error('Wrong Number of input arguments')
end
