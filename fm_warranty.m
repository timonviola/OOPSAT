function fig = fm_warranty(varargin)
% FM_WARRANTY create GUI for the PSAT warranty
%
% HDL = FM_WARRANTY()
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    10-Feb-2003
%Version:   1.0.2
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

global Settings Fig Path Theme

if nargin
  switch varargin{1}

   case 'keyesc'

    tasto = get(gcf,'CurrentCharacter');
    if (double(tasto) == 13 || double(tasto) == 27), close(gcf); end

  end
  return
end

if ishandle(Fig.warranty), figure(Fig.warranty), return, end

helpstr = help('gnuwarranty');
retidx = findstr(helpstr,char(10));
retidx = [0,retidx,length(helpstr)+1];
testo = cell(length(retidx)-1,1);
for i = 1:length(retidx)-1
  testo{i} = helpstr([retidx(i)+1:retidx(i+1)-1]);
end

h0 = figure('Color',Theme.color01, ...
            'Units', 'normalized', ...
            'Colormap',[], ...
            'CreateFcn','Fig.warranty = gcf;', ...
            'DeleteFcn','Fig.warranty = -1;', ...
            'FileName', 'fm_warranty', ...
            'KeyPressFcn','fm_warranty keyesc', ...
            'MenuBar','none', ...
            'Name','NO WARRANTY', ...
            'NumberTitle','off', ...
            'PaperPosition',[18 180 576 432], ...
            'PaperUnits','points', ...
            'Position',sizefig(1.15*0.5,1.15*0.357), ...
            'Resize','on', ...
            'ToolBar','none');

fm_set colormap

% Menu File
h1 = uimenu('Parent',h0, ...
	    'Label','File', ...
	    'Tag','MenuFile');
h2 = uimenu('Parent',h1, ...
	    'Callback','close(gcf)', ...
	    'Label','Exit', ...
	    'Tag','NetSett', ...
	    'Accelerator','x');

h1 = axes('Parent',h0, ...
          'Box','on', ...
          'CameraUpVector',[0 1 0], ...
          'CameraUpVectorMode','manual', ...
          'Color',Theme.color04, ...
          'ColorOrder',Settings.color, ...
          'HitTest','off', ...
          'Layer','top', ...
          'Position',[0.1*0.5690, 0.25, 0.6*0.5690, 0.65], ...
          'Tag','Axes1', ...
          'XColor',Theme.color05, ...
          'XLim',[0.5 973.5], ...
          'XLimMode','manual', ...
          'XTickLabelMode','manual', ...
          'XTickMode','manual', ...
          'XTick',[], ...
          'YColor',Theme.color05, ...
          'YDir','reverse', ...
          'YLim',[0.5 688.5], ...
          'YLimMode','manual', ...
          'YTickLabelMode','manual', ...
          'YTickMode','manual', ...
          'YTick',[], ...
          'ZColor',[0 0 0]);
if Settings.hostver < 8.04
  h2 = image('Parent',h1, ...
             'CData',imread([Path.images,'misc_lines.jpg'],'jpg'), ...
             'Tag','Axes1Image1', ...
             'XData',[1 973], ...
             'YData',[1 688]);
else
  h2 = image('Parent',h1, ...
             'CData',flipud(fliplr(imread([Path.images,'misc_lines.jpg'],'jpg'))), ...
             'Tag','Axes1Image1', ...
             'XData',[1 973], ...
             'YData',[1 688]);
end
h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color11, ...
               'Enable','inactive', ...
               'ForegroundColor',Theme.color05, ...
               'HorizontalAlignment','left', ...
               'Min', 0, ...
               'Max', 2, ...
               'Position',[1-0.95*0.5690, 0.1, 0.85*0.5690, 0.8], ...
               'String',testo, ...
               'Style','listbox', ...
               'Value',[], ...
               'Tag','Listbox1');

if isunix, set(h1,'Enable','on'), end

h1 = uicontrol('Parent',h0, ...
               'Units', 'normalized', ...
               'BackgroundColor',Theme.color03, ...
               'ForegroundColor',Theme.color09, ...
               'Callback','close(gcf)', ...
               'String','OK', ...
               'Position',[0.25*0.5690, 0.1, 0.3*0.5690, 0.0975], ...
               'Tag','Pushbutton1');
if nargout > 0, fig = h0; end
