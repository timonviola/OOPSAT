function fig = fm_pset()
% FM_PSET create GUI for UDM parameter settings
%
% FM_PSET()
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

global Theme Fig Param

if ishandle(Fig.pset), figure(Fig.pset), return, end

unitparametri = {'None';'Second';'1/second';'rad';'rad/s';'p.u.'; ...
                 'p.u./p.u.';'Volt';'Ampere';'Herz';'MWatt';'MVAr';'MVA'};
tipiparametri = {'None';'Time Constant';'Reactance';'Resistence'; ...
                 'Inverse Time Constant'; 'Pure Number';'Gain';'Power'; ...
                 'Current'; 'Voltage'; 'Frequency'};

h0 = figure('Color',Theme.color01, ...
	    'Units', 'normalized', ...
	    'CreateFcn','Fig.pset = gcf;', ...
	    'DeleteFcn','Fig.pset = -1;', ...
	    'Colormap',[], ...
	    'FileName','fm_pset', ...
	    'MenuBar','none', ...
	    'Name','Parameter Settings', ...
	    'NumberTitle','off', ...
	    'PaperPosition',[18 180 576 432], ...
	    'PaperType','A4', ...
	    'PaperUnits','points', ...
	    'Position',sizefig(1.2*0.2375,1.25*0.3000), ...
	    'Resize','on', ...
	    'ToolBar','none');

% Frame for parameters and settings
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.1000   0.2750   0.8000   0.4500], ...
	       'Style','frame', ...
	       'Tag','Frame1');

% Popup Menus
h(1) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.5977   0.3500   0.0651], ...
		 'String',unitparametri, ...
		 'Style','popupmenu', ...
		 'Tag','PopupMenu1', ...
		 'Value',1);
h(2) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000   0.4675   0.3500   0.0651], ...
		 'String',tipiparametri, ...
		 'Style','popupmenu', ...
		 'Tag','PopupMenu2', ...
		 'Value',1);

% Push buttons
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color03, ...
	       'Callback','fm_comp pset', ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color09, ...
	       'Position',[0.1000   0.0500*1.5917   0.2333   0.0700*1.5917], ...
	       'String','Ok', ...
	       'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_comp pset', ...
	       'Position',[0.3833   0.0500*1.5917   0.2333   0.0700*1.5917], ...
	       'String','Apply', ...
	       'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','close(gcf)', ...
	       'Position',[0.6666   0.0500*1.5917   0.2333   0.0700*1.5917], ...
	       'String','Cancel', ...
	       'Tag','Pushbutton3');


% Edit text
h(3) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'FontName',Theme.font01, ...
		 'ForegroundColor',Theme.color05, ...
		 'HorizontalAlignment','left', ...
		 'Position',[0.5000     0.3372     0.3500    0.0651], ...
		 'Style','edit', ...
		 'Tag','EditText2');

% Frame and edit text for the variable name
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color04, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.1000   0.8090   0.8000   0.0955], ...
	       'Style','frame', ...
	       'Tag','Frame1');
h(4) = uicontrol('Parent',h0, ...
		 'Units', 'normalized', ...
		 'BackgroundColor',Theme.color04, ...
		 'FontWeight','bold', ...
		 'ForegroundColor',Theme.color07, ...
		 'Position',[0.2000   0.8170   0.6000   0.0637], ...
		 'Style','text', ...
		 'Tag','StaticText4');

% Static texts
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color01, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.5977   0.3250   0.0651], ...
	       'String','Unit', ...
	       'Style','text', ...
	       'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color01, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.4675   0.3250   0.0651], ...
	       'String','Type', ...
	       'Style','text', ...
	       'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color01, ...
	       'HorizontalAlignment','right', ...
	       'Position',[0.1500   0.3372   0.3250   0.0651], ...
	       'String','Description', ...
	       'Style','text', ...
	       'Tag','StaticText3');

set(h0,'UserData',h)
if nargout > 0, fig = h0; end
