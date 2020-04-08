function fig = fm_xset()
% FM_XSET create GUI for UDM state variables
%
% HDL = FM_XSET()
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

global Theme Fig State

if ishandle(Fig.xset), figure(Fig.xset), return, end

h0 = figure('Color',Theme.color01, ...
	    'Units', 'normalized', ...
	    'Colormap',[], ...
	    'CreateFcn','Fig.xset = gcf;', ...
	    'DeleteFcn','Fig.xset = -1;', ...
	    'FileName','fm_xset', ...
	    'MenuBar','none', ...
	    'Name','State Variable Settings', ...
	    'NumberTitle','off', ...
	    'PaperPosition',[18 180 576 432], ...
	    'PaperType','A4', ...
	    'PaperUnits','points', ...
	    'Position',sizefig(1.2*0.2375,1.25*0.4775), ...
	    'Resize','on', ...
	    'ToolBar','none');

% Frame for parameters and settings
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.1000   0.1600   0.8000   0.6900], ...
	       'Style','frame', ...
	       'Tag','Frame1');

% Popup menus
h(1) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.5153   0.3500   0.0409], ...
		 'Style','popupmenu', ...
		 'Tag','PopupMenu1', ...
		 'Value',1);
h(2) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.5971   0.3500   0.0409], ...
		 'Style','popupmenu', ...
		 'Tag','PopupMenu2', ...
		 'Value',1);
h(3) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'Callback','fm_comp xtime', ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.7587   0.3500   0.0409], ...
		 'Style','popupmenu', ...
		 'Tag','PopupMenu5', ...
		 'Value',1);
h(4) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.6769   0.3500   0.0409], ...
		 'String',{'No';'Yes'}, ...
		 'Style','popupmenu', ...
		 'Tag','PopupMenu3', ...
		 'Value',1);
h(5) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.4356   0.3500   0.0409], ...
		 'String',{'No';'Yes'}, ...
		 'Style','popupmenu', ...
		 'Tag','PopupMenu4', ...
		 'Value',1);


% Push buttons
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color03, ...
	       'Callback','fm_comp xset', ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color09, ...
	       'Position',[0.1000   0.0500   0.2333   0.0700], ...
	       'String','Ok', ...
	       'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_comp xset', ...
	       'Position',[0.3833   0.0500   0.2333   0.0700], ...
	       'String','Apply', ...
	       'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','close(gcf)', ...
	       'Position',[0.6666   0.0500   0.2333   0.0700], ...
	       'String','Cancel', ...
	       'Tag','Pushbutton3');


% Frame and edit text for the variable name
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color04, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.1000   0.8800   0.8000   0.0600], ...
	       'Style','frame', ...
	       'Tag','Frame1');
h(6) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'FontWeight','bold', ...
		 'ForegroundColor',Theme.color07, ...
		 'Position',[0.2000   0.8850   0.6000   0.0400], ...
		 'Style','text', ...
		 'Tag','StaticText3');

% Static texts
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.5971   0.3250   0.0409], ...
	       'String','Superior Limit', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.5153   0.3250   0.0409], ...
	       'String','Inferior Limit', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.7587   0.3250   0.0409], ...
	       'String','Time Constant', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.6769   0.3250   0.0409], ...
	       'String','No dynamic', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.2065   0.3250   0.0409], ...
	       'String','Initial guess', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.4356   0.3250   0.0409], ...
	       'String','Offset', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.3579   0.3250   0.0409], ...
	       'String','Matlab Name', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.2822   0.3250   0.0409], ...
	       'String','TeX Name', ...
	       'Style','text', ...
	       'Tag','StaticText2');


% Edit texts
h(7) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'Callback','fval(gcbo,get(gcbo,''UserData''),0);', ...
		 'BackgroundColor',Theme.color04, ...
		 'FontName',Theme.font01, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.2065   0.3500   0.0409], ...
		 'Style','edit', ...
		 'Tag','EditText1');
h(8) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'Enable','inactive', ...
		 'FontName',Theme.font01, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.3579   0.3500   0.0409], ...
		 'Style','edit', ...
		 'Tag','Edit_uname');
h(9) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'FontName',Theme.font01, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.2822   0.3500   0.0409], ...
		 'Style','edit', ...
		 'Tag','Edit_fname');

set(h0,'UserData',h)
if nargout > 0, fig = h0; end
