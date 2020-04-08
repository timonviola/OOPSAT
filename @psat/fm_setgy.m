function fm_setgy(obj,varargin)

switch nargin-1
  case 1
    idx = varargin{1};
    type = 1;
  case 2
    idx = varargin{1};
    type = varargin{2};
end

if isempty(idx), return, end

switch type
  case 1
    obj.DAE.Gy(idx,:) = 0;
    obj.DAE.Gy(:,idx) = 0;
    obj.DAE.Gy = obj.DAE.Gy + sparse(idx,idx,1,obj.DAE.m,obj.DAE.m);
  case 2
    obj.DAE.Gy(idx,:) = 0;
    obj.DAE.Gy(:,idx) = 0;
    obj.DAE.Gy = obj.DAE.Gy + sparse(idx,idx,1,obj.DAE.m,obj.DAE.m);
    obj.DAE.Fy(:,idx) = 0;
    obj.DAE.Gx(idx,:) = 0;
end
