function Fxcall(p,psat_obj,varargin)
if ~p.n, return, end

if nargin == 2
  type = 'all';
else
  type = varargin{1};
end

idx = p.vbus(find(p.u));

if isempty(idx),return, end

psat_obj.DAE.Fy(:,idx) = 0;
psat_obj.DAE.Gx(idx,:) = 0;

if strcmp(type,'onlyq'), return, end

idx = p.bus(find(p.u));
psat_obj.DAE.Fy(:,idx) = 0;
psat_obj.DAE.Gx(idx,:) = 0;

