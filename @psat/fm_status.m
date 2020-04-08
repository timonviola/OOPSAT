function fm_status(obj,varargin)
% FM_STATUS display convergence error of the current simulation in
%           the main window
%
% FM_STATUS('init',xmax,colors,styles,faces)
% FM_STATUS('update',values,iteration,err_max)
%
%see also the structure Hdl
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    09-Jul-2003
%Version:   1.0.1
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

% global Settings Fig Hdl Theme CPF OPF
% 
% persistent handles
% persistent status
% persistent firstvalue
% persistent hdl

if (nargin-1)
  routine = varargin{1};
  flag = varargin{2};
else
  return
end

switch routine
 case 'pf'
  check = obj.Settings.status;
 case 'opf'
  check = obj.OPF.show;
 case 'cpf'
  check = obj.CPF.show;
 case 'lib'
  check = obj.Settings.status;
 case 'snb'
  check = obj.Settings.status;
end

if ~(obj.Settings.show && check && ishandle(obj.Fig.main)), return, end

switch flag
 case 'init'

  xmax = varargin{3};
  colors = varargin{4};
  styles = varargin{5};
  faces = varargin{6};
  if nargin > 6
    yrange = varargin{7};
  else
    yrange = [0 1];
  end

  if ishandle(obj.Hdl.status), delete(obj.Hdl.status); end

  obj.hdl = findobj(obj.Fig.main,'Tag','PushClose');
  set(obj.hdl,'String','Stop');
  set(obj.Fig.main,'UserData',1);

  set(0,'CurrentFigure',obj.Fig.main);
  obj.Hdl.status = axes('position',[0.0406 0.1152 0.2537 0.2243]);
  if obj.Settings.hostver < 8.04
    set(obj.Hdl.status, ...
        'Drawmode','fast', ...
        'NextPlot','add', ...
        'Color',obj.Theme.color1, ...
        'Xlim',[1 xmax], ...
        'Ylim',yrange, ...
        'Box','on');
  else
    set(obj.Hdl.status, ...
        'NextPlot','add', ...
        'Color',obj.Theme.color04, ...
        'Xlim',[1 xmax], ...
        'Ylim',yrange, ...
        'Box','on');
    %'SortMethod','depth', ...
  end
  grid('on')

  obj.handles = zeros(length(colors),1);
  for i = 1:length(colors)
    if obj.Settings.hostver < 8.04
      obj.handles(i) = line('Color',colors{i}, ...
                        'LineStyle',styles{i}, ...
                        'Marker','o', ...
                        'MarkerSize',5, ...
                        'XData',[1 1], ...
                        'YData',[100 100], ...
                        'Erase','none', ...
                        'MarkerFaceColor',faces{i});
    else
      obj.handles(i) = line('Color',colors{i}, ...
                        'LineStyle',styles{i}, ...
                        'Marker','o', ...
                        'MarkerSize',5, ...
                        'MarkerFaceColor',faces{i});
    end
  end
  drawnow
  obj.status = [];

 case 'update'

  values = varargin{3};
  iteration = varargin{4};

  if iteration == 1
    obj.firstvalue = values(2:end);
    if ~obj.firstvalue, obj.firstvalue = 1; end
    values(2:end) = 1;
  else
    values(2:end) = abs(values(2:end))./obj.firstvalue;
  end

  obj.status = [obj.status; values];

  for i = 1:length(obj.handles)
    if obj.status(1,i+1) == 0
      obj.status(1,i+1) = 1;
    end
    if obj.Settings.hostver < 8.04
      set(obj.handles(i), ...
          'xdata',obj.status([max(end-1,1),end],1), ...
          'ydata',obj.status([max(end-1,1),end],i+1));
      drawnow
    else
      % display(status(end,1))
      % display(status(end,i+1))
      % help addpoints
      set(obj.handles(i), ...
          'XData', obj.status([1:end], 1), ...
          'YData', obj.status([1:end], i+1))
      drawnow update
    end
  end

 case 'close'

  set(obj.hdl,'String','Close');

end
