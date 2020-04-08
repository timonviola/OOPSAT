classdef psat < handle
    %PSAT application instance that corresponds to a loaded case. The
    % purpose of oop is better maintainability and being able to run
    % multiple PSAT instances. There is one rule above all: NEVER USE
    % GLOBAL VARIABLES.
    
    properties
        % All the contents of fm_var
        %     General System Variables
        Settings
        Fig 
        Path
        File
        Hdl
        clpsat
        History
        Snapshot
        Theme
        Source
        jay
        %     User Defined Model variables
        Comp
        Algeb
        Buses 
        Initl
        Param
        Servc 
        State
        %     Outputs and variable names
        Varout
        Varname
        %     Basic System structures
        DAE
        LIB 
        SNB 
        OPF 
        CPF 
        SSSA 
        PMU 
        OMIB
        %     Interface Structures
        GAMS
        UWPFLOW
        %     Structure for linear analysis
        LA 
        EQUIV
        %     Traditional Power Flow Buses
        Bus
        Areas 
        Regions 
        Line 
        SW 
        PV 
        PQ 
        Shunt 
        Lines 
        Twt 
        PQgen
        %     Static and dynamic nonlinear loads
        Pl
        Mn
        Fl 
        Thload 
        Tap
        %     Components for CPF and OPF
        Demand 
        Supply 
        Rsrv 
        Rmpg 
        Rmpl 
        Vltn 
        Ypdp
        %     Fault Variables
        Fault 
        Breaker
        %     Basic Dyanmic Components
        Syn 
        Ind 
        Ltc
        %     Regulators
        Exc
        Tg 
        Pss 
        Oxl 
        Pod 
        COI
        %     FACTS
        Svc
        Tcsc 
        Statcom 
        Sssc 
        Upfc
        %     HVDC components
        Hvdc
        %     Other dynamic components
        Mass 
        SSR
        %     Fuel Cell Model
        Sofc
        %     Secondary Voltage Regulation
        Cac 
        Cluster
        %     Exponential recovery load
        Exload
        %     Phase Shifting Transformer
        Phs
        %     Wind Turbine
        Wind
        Cswt 
        Dfig 
        Ddsg 
        WTFR
        %     Measurements
        Busfreq 
        Pmu
        %     Jimma's load
        Jimma
        %     Mixed load
        Mixload
        %     Solar Photo-Voltaic Generators
        Spv
        Spq
    end
    
    methods
        % CONSTRUCTOR
        function obj = psat(varargin)
            %PSAT Construct an instance of the application
            %   Detailed explanation goes here
            %
            % Inputs (all optional):
            % COMMAND_LINE_PSAT - run psat in cli mode
            
            p = inputParser;
            p.KeepUnmatched = true;
            defaultMode = false;
            defaultSplash = false;
            addParameter(p,'nosplash',defaultSplash,@islogical)
            addParameter(p,'command_line_psat',defaultMode,@islogical)
            parse(p,varargin{:});
            % end of shitty matlab input parser syntax
            command_line_psat = p.Results.command_line_psat;
            nosplash = p.Results.nosplash;
            a = version;
            a = str2num(a(1:3));                    %#ok
            if ~exist('OCTAVE_VERSION')              %#ok
              if a < 5.3
                disp('PSAT needs a Matlab version >= 5.3')
                return
              elseif a < 7.0
                disp(['For Matlab versions < 7.0, PSAT runs only ' ...
                      'in the command line mode'])
                command_line_psat = 1;
              end
            end

            psatver = '2.1.11';
            psatdate = 'August 17, 2019';

            failed = 0; %#ok
            if (((exist('nosplash','var') == 1) && (nosplash == 0)) || (exist('nosplash','var') ~= 1))
                disp(' ')
                disp('                        < P S A T >')
                disp('          Copyright (C) 2002-2019 Federico Milano')
                disp([blanks(30-floor(5+length(psatver)/2)),'Version ',psatver])
                disp([blanks(30-ceil(length(psatdate)/2)),psatdate])
                disp('  ')
                disp('PSAT comes with ABSOLUTELY NO WARRANTY; type ''gnuwarranty''')
                disp('for details. This is free software, and you are welcome to')
                disp(['redistribute it under certain conditions; type' ...
                      ' ''gnulicense'''])
                disp('for details.')
                disp('  ')
                if exist('OCTAVE_VERSION') %#ok
                  disp(['Host:         Octave ',version])
                else
                  disp(['Host:         Matlab ',version])
                end
                disp(['Session:      ', datestr(now,0)])
                if command_line_psat
                  disp('Usage:        Command Line')
                else
                  disp('Usage:        Graphical User Interface')
                end
                disp(['Path:         ',pwd])
                disp(' ')
            end
            
            psatdir = which('psat.m');
            %psatdir = psatdir(1:end-7);
            % searching the "PSAT" path
            % Since there is a class folder now we are going for 2 folders
            % above:
            nAbove = 2;
            parts = strsplit(psatdir,filesep);
            psatdir = strjoin(parts(1:end-nAbove),filesep);
            
            if strcmp(psatdir,'.'), psatdir = pwd; end
            
            % check for Octave
            if exist('OCTAVE_VERSION') && isempty(findstr(path,[psatdir,filesep,'@BUclass'])) %#ok
              folders = dir([psatdir,filesep,'@*']);
              for i = length(folders):-1:1
                if folders(i).isdir
                  %addpath([psatdir,filesep,folders(i).name])
                end
              end
              %addpath([psatdir,filesep,'filters'])
              %addpath(psatdir)
              clear folders
            end

            % check for Matlab
            if isempty(strmatch(path,[psatdir,filesep,'filters'],'exact')) %#ok
              %addpath([psatdir,filesep,'filters'])%TODO: REMOVE THIS
            end
            if isempty(strmatch(path,psatdir,'exact'))  %#ok
%               addpath(psatdir)
            end

%% SCRIPT CALL:   fm_var
            obj.Path = struct('data','','local','','psat','','pert','', ...
              'build','','images','','themes','', ...
              'filters','','temp',''); %#ok
          
            % CLI settings
            if command_line_psat
              obj.clpsat.init = 1;
              obj.clpsat.mesg = 1;
              obj.clpsat.refresh = 1;
              obj.clpsat.refreshsim = 0;
              obj.clpsat.readfile = 1;
              obj.clpsat.showopf = 0;
              obj.clpsat.pq2z = 1;
              obj.clpsat.viewrep = 0;
            else
              obj.clpsat.init = 0;
              obj.clpsat.mesg = 1;
              obj.clpsat.refresh = 0;
              obj.clpsat.refreshsim = 0;
              obj.clpsat.readfile = 1;
              obj.clpsat.showopf = 1;
              obj.clpsat.pq2z = 1;
              obj.clpsat.viewrep = 1;
            end
            
            % Path checks
            obj.Path.local = [pwd,filesep];
            if exist('OCTAVE_VERSION') %#ok
              obj.Path.psat = strrep(which('psat'),'psat.m','');
            else
              if strncmp(computer,'GLNX',4)
                obj.Path.local = strrep(obj.Path.local,'~',getenv('HOME'));
              end
              obj.Path.psat = [psatdir,filesep];
              if strcmp(computer,'GLNX86')
                obj.Path.psat = strrep(obj.Path.psat,'~',getenv('HOME'));
              end
            end
            obj.Path.build   = [obj.Path.psat,'build',  filesep];
            obj.Path.images  = [obj.Path.psat,'images', filesep];
            obj.Path.themes  = [obj.Path.psat,'themes', filesep];
            obj.Path.filters = [obj.Path.psat,'filters',filesep];
            
            if exist(obj.Path.build) ~= 7 %#ok
              disp('No "build" folder found in the current PSAT path.')
              failed = ~mkdir(obj.Path.psat,'build');
              if failed
                disp('The folder "build" could not be created')
              end
            end
            if exist(obj.Path.images) ~= 7  %#ok
              disp('No "images" folder found in the current PSAT path.')
              failed = 1;
            end
            if exist(obj.Path.themes) ~= 7  %#ok
              disp('No "themes" folder found in the current PSAT path.')
              failed = ~mkdir(obj.Path.psat,'themes');
              if failed
                disp('The folder "themes" could not be created')
              end
            end
            if exist(obj.Path.filters) ~= 7 %#ok
              disp('No "filters" folder found in the current PSAT path.')
              failed = 1;
            end
            if failed
              disp('The PSAT folder seems to be uncomplete and needs to be installed again.')
              disp('PSAT initialization failed.')
              return
            end

            % more CLI mode checks
            if ~command_line_psat
%% SCRIPT CALL: fm_enter
              [hdl,htxt] = obj.fm_enter(psatdir,psatver,psatdate);  %#ok
              pause(0.1)
              hold on
              % the size of the splash window are 346 x 410 pixels
              if version < 8
                hdlp = patch([8 8 41 41 8],[405 395 395 405 405], ...
                             [0.50 0.45 0.95],'EdgeColor',[1 1 1]);
                set(hdlp,'EraseMode','none');
              else
                hdlp = patch([8 8 41 41 8],[5 15 15 5 5], ...
                             [0.50 0.45 0.95],'EdgeColor',[1 1 1]);
              end
              set(htxt,'Color',[0.4 0.4 0.4],'String','Initializing History...')
              drawnow
            end
    
            obj.File = struct('data','','pert','','temp','','modify','');
            obj.Source = struct('data','','pert','','description','');

            obj.jay = sqrt(-1);

            obj.History = struct('text','', ...
                             'index',1, ...
                             'string','', ...
                             'workspace',0, ...
                             'Max',500, ...
                             'FontName', ...
                             'Courier', ...
                             'FontSize',12, ...
                             'FontAngle','normal', ...
                             'FontWeight','normal', ...
                             'BackgroundColor','w', ...
                             'ForegroundColor','k');

            obj.History.text = {['PSAT version ',psatver, ...
                     ', Copyright (C) 2002-2019 Federico Milano']; ...
                    ' '; ['Session  ', datestr(now)]};
            
            if ~command_line_psat
              set(hdlp,'XData',[8 8 74 74 8])
              set(htxt,'String','Initializing Settings...')
              drawnow
            end

            try
%% call to settings() function check if this truly works as expected on handle class 
                obj.settings
            catch
              obj.Theme = struct('color01',[0.800 0.800 0.800], ...
                             'color02',[0.753 0.753 0.753], ...
                             'color03',[0.502 0.502 0.502], ...
                             'color04',[1.000 1.000 1.000], ...
                             'color05',[0.000 0.000 0.502], ...
                             'color06',[1.000 1.000 0.502], ...
                             'color07',[0.502 0.000 0.000], ...
                             'color08',[0.750 0.390 0.503], ...
                             'color09',[1.000 1.000 1.000], ...
                             'color10',[1.000 1.000 1.000], ...
                             'color11',[0.920 0.920 0.920], ...
                             'font01','Courier','hdl',zeros(18,1));

              obj.Settings = struct( ...
                  'pq2z',0, ...
                  'pv2pq',0, ...
                  'pv2pqniter',0, ...
                  'multipvswitch',0, ...
                  'showlf',0, ...
                  'init', 0, ...
                  'status', 1, ...
                  'conv', 1, ...
                  'plot',0, ...
                  'plottype',1, ...
                  'method',2, ...
                  'show',1, ...
                  'vs',0, ...
                  'ok',0, ...
                  'pfsolver', 1, ...
                  'deltadelta',180, ...
                  'checkdelta',0, ...
                  'deltat',1e-5, ...
                  'deltatmax',1e-3, ...
                  'deltatmin',1e-5, ...
                  'chunk',100, ...
                  'maxvar',1500, ...
                  'maxsimout', 15, ...
                  'maxsimin', 15, ...
                  'mv',0, ...
                  'nseries',0, ...
                  'iter',0, ...
                  'static', 0, ...
                  'zoom','', ...
                  'freq', 50, ...
                  'beep',0, ...
                  'dyntol',1e-5, ...
                  'dynmit',20, ...
                  'lftol',1e-5, ...
                  'lfmit',20, ...
                  'lftime', 0, ...
                  't0',0, ...
                  'tf',30, ...
                  'mva',100, ...
                  'rad',2*3.14159265358979*50, ...
                  'distrsw', 0, ...
                  'color',[], ...
                  'fixt',0, ...
                  'tstep',0.001, ...
                  'xlabel','time (s)', ...
                  'locksnap',0, ...
                  'tviewer',[], ...
                  'absvalues', 'off', ...
                  'violations', 'off', ...
                  'error', 1, ...
                  'export','txt', ...
                  'noarrows',1, ...
                  'matlab',1, ...
                  'octave',0, ...
                  'local',1, ...
                  'simtd',0, ...
                  'forcepq',0, ...
                  'switch2nr',0, ...
                  'resetangles',1, ...
                  'format',1, ...
                  'coi',0, ...
                  'platform','UNIX', ...
                  'report',0, ...
                  'donotask',0, ...
                  'usedegree',0, ...
                  'usehertz',0, ...
                  'userelspeed',0);
            end

            obj.Settings.color = [0      0      1.0000;
                              0      0.5000 0;
                              1.0000 0      0;
                              0      0.7500 0.7500;
                              0.7500 0      0.7500;
                              0.7500 0.7500 0;
                              0.2500 0.2500 0.2500];

            if ~command_line_psat
              obj.Theme.color01.DefaultUicontrolBackgroundColor = 0;
            end
            
            a = version;
            idx = findstr(a, '.');  %#ok
            obj.Settings.hostver = str2num(a(1:idx(1)-1)) + 0.01*str2num(a(idx(1)+1:idx(2)-1)); %#ok
            obj.Settings.init = 0;
            obj.Settings.donotask = 0;
            obj.Settings.version = psatver;
            obj.Settings.date = psatdate;
            if exist('OCTAVE_VERSION') %#ok
              obj.Settings.octave = 1;
              obj.Settings.matlab = 0; %#ok
            else
              obj.Settings.octave = 0;
              obj.Settings.matlab = 1; %#ok
            end
            if ~isfield(obj.Settings,'local')
              obj.Settings.local = 1;
            end

            if isunix && strcmp(obj.Settings.export,'xls')
              obj.Settings.export = 'txt';
            end

            switch computer
             case 'PCWIN'
              obj.Settings.tviewer = '!notepad ';
             otherwise
              obj.Settings.tviewer = '!cat ';
            end

            if obj.Settings.octave
              obj.Settings.platform = computer;
            else
              if strncmp(computer,'PC',2)
                obj.Settings.platform = 'PC';
              elseif strncmp(computer,'MAC',3) && usejava('jvm')
                obj.Settings.platform = 'MAC';
              else
                obj.Settings.platform = 'UNIX';
              end
            % avoid annoying warning message of Simulink models
              if obj.Settings.hostver >= 9.05
                warning('off','Simulink:Engine:InvalidDomainRegistrationKey');
                %warning('off','all');
              end

              % Use default colors if the Java Desktop is in use
              if obj.Settings.hostver >= 6.1
                if usejava('jvm')
                  obj.Theme.color01 = get(0,'factoryUicontrolBackgroundColor');
                  obj.Theme.color02 = get(0,'factoryUicontrolBackgroundColor');
                  obj.Theme.color03 = get(0,'factoryUicontrolBackgroundColor');
                  if obj.Settings.hostver < 8.04
                    obj.Theme.color04 = get(0,'factoryAxesXColor');
                  else
                    obj.Theme.color04 = [1, 1, 1];
                  end
                  obj.Theme.color05 = get(0,'factoryUicontrolForegroundColor');
                  obj.Theme.color06 = get(0,'factoryUicontrolForegroundColor');
                  obj.Theme.color07 = get(0,'factoryUicontrolForegroundColor');
                  obj.Theme.color09 = get(0,'factoryUicontrolForegroundColor');
                  obj.Theme.color10 = get(0,'factoryUicontrolForegroundColor');
                  obj.Theme.color11 = obj.Theme.color04;
                  if obj.Settings.platform(1:2) ~= 'PC' %#ok
                    obj.Theme.font01 = get(0,'factoryTextFontName');
                    obj.Theme.font02 = get(0,'factoryTextFontName');
                    obj.Theme.font03 = get(0,'factoryTextFontName');
                    obj.Theme.font04 = get(0,'factoryTextFontName');
                  end
                end
              end
            end
            
            obj.Hdl = struct('hist',-1, ...
             'text',-1, ...
             'status',-1, ...
             'frame',-1, ...
             'bar',-1, ...
             'pert','');

            if obj.Settings.hostver >= 6
              obj.Hdl.pert = str2func('pert');
            else
              obj.Hdl.pert = 'pert';
            end

            obj.Fig = struct('main',-1, ...
             'plot',-1, ...
             'update',-1, ...
             'hist',-1, ...
             'pset',-1, ...
             'make',-1, ...
             'lib',-1, ...
             'comp',-1, ...
             'cset',-1, ...
             'sset',-1, ...
             'xset',-1, ...
             'eigen',-1, ...
             'matrx',-1, ...
             'theme',-1, ...
             'simset',-1, ...
             'setting',-1, ...
             'snap',-1, ...
             'stat',-1, ...
             'pmu',-1, ...
             'dir',-1, ...
             'cpf',-1, ...
             'snb',-1, ...
             'about',-1, ...
             'author',-1, ...
             'opf',-1, ...
             'line',-1, ...
             'clock',-1, ...
             'license',-1, ...
             'warranty',-1, ...
             'tviewer',-1, ...
             'gams',-1, ...
             'uwpflow',-1, ...
             'laprint',-1, ...
             'plotsel',-1, ...
             'threed',-1, ...
             'equiv',-1, ...
             'bus',-1, ...
             'advanced',-1);

            % Component Structures
            % clear Comp
            obj.Comp.prop = [];
            obj.Comp.n = 0;
            obj.Comp.init = 0;
            obj.Comp.descr = '';
            obj.Comp.name = '';
            obj.Comp.shunt = 1;
            obj.Comp.series = 0;
            
            if ~command_line_psat
              set(hdlp,'XData',[8 8 107 107 8])
              set(htxt,'String','Initializing "namevar[xy].ini"...')
              drawnow
            end
            
            % Output Variables and Names Structures
            obj.Varout = struct('t',[],'vars',[],'idx',[],'surf',0,'hdl',[],'zlevel',0, ...
                            'movie',[],'alpha',1,'caxis',0,'xb',[],'yb',[]);
            obj.Varname = struct('compx','','unamex','','fnamex','', ...
                             'compy','','unamey','','fnamey','', ...
                             'uvars','','fvars','','nvars',0, ...
                             'idx',[],'custom',0,'fixed',1, ...
                             'x',1,'y',1,'P',0,'Q',0, ...
                             'Pij',0,'Qij',0,'Iij',0,'Sij',0,'pos',[], ...
                             'areas',0,'regions',0);
            % Snapshots
            obj.Snapshot = struct('name','', 'time',obj.Settings.t0, ...
                              'y',[], 'x', [], 'Ybus', [], 'Pg', [], ...
                              'Qg', [], 'Pl', [], 'Ql', [],  ...
                              'Gy', [], 'Fx', [], 'Fy', [], 'Gx', [], ...
                              'Ploss', [], 'Qloss', [], 'it', 0);

            filemode = 'rt';
            % State variable names
            fid = fopen([obj.Path.psat,'namevarx.ini'],filemode);
            if fid == -1
              disp('#Error: File "namevarx.ini" cannot be open.')
              failed = 1;   %#ok
            else
              nname = 0;
              while 1
                sline = fgetl(fid);
                if ~ischar(sline), break; end
                try
                  obj.Varname.unamex{nname+1,1} = deblank(sline(1:20));
                  obj.Varname.fnamex{nname+1,1} = deblank(sline(21:40));
                  obj.Varname.compx{nname+1,1}  = deblank(sline(41:end));
                  if obj.Settings.octave && strcmp(obj.Varname.compx{nname+1,1}(end),'\r')
                    obj.Varname.compx{nname+1,1} = obj.Varname.compx{nname+1,1}(1:end-1);
                  end
                  nname = nname + 1;
                catch
                  % nothing to do ...
                end
              end
              count = fclose(fid);
            end
            
            % Algebraic variable names
            fid = fopen([obj.Path.psat,'namevary.ini'],filemode);
            if fid == -1,
              disp('#Error: File "namevary.ini" cannot be open.')
              failed = 1;
            else
              nname = 0;
              while 1
                sline = fgetl(fid);
                if ~ischar(sline), break; end
                try
                  obj.Varname.unamey{nname+1,1} = deblank(sline(1:20));
                  obj.Varname.fnamey{nname+1,1} = deblank(sline(21:40));
                  obj.Varname.compy{nname+1,1}  = deblank(sline(41:end));
                  if Settings.octave && strcmp(obj.Varname.compy{nname+1,1}(end),'\r')
                    obj.Varname.compx{nname+1,1} = obj.Varname.compy{nname+1,1}(1:end-1);
                  end
                  nname = nname + 1;
                catch
                  % nothing to do ...
                end
              end
              count = fclose(fid);
            end             
            if ~command_line_psat
              set(hdlp,'XData',[8 8 140 140 8])
              set(htxt,'String','Initializing "history.ini"...')
              drawnow
            end
            
%% PROBLEM - with .ini file and with eval
            fid = fopen([obj.Path.psat,'history.ini'],filemode);
            if fid == -1,
              disp('#Error: File "history.ini" cannot be open.')
              failed = 1;
            else
              while 1
                sline = fgetl(fid);
                if obj.Settings.octave
                  sline = sline(1:end-1);
                end
                if ~ischar(sline), break, end
                try % THIS EVAL IS A PROBLEM!
                  %eval(['History.',sline(1:19),' = ',sline(20:end),';']);
                catch
                  % nothing to do ...
                end
              end
              count = fclose(fid);
            end
            
            if ~command_line_psat
              set(hdlp,'XData',[8 8 173 173 8])
              set(htxt,'String','Initializing "comp.ini"...')
              drawnow
            end
            % Existing components functions
%PROBLEM with INI file
            fid = fopen([obj.Path.psat,'comp.ini'],filemode);
            if fid == -1
              disp('#Error: File "comp.ini" cannot be open.')
              failed = 1; %#ok
            else
              ncomp=0;
              while 1
                sline = fgetl(fid);
                if ~ischar(sline), break; end
                try
                  obj.Comp.names{ncomp+1,1} = deblank(sline(1:21));
                  obj.Comp.prop(ncomp+1,:) = str2num(sline(22:38)); %#ok
                  ncomp = ncomp + 1;
                catch
                  % nothing to do ...
                end
              end
              count = fclose(fid); %#ok
              obj.Comp.names{ncomp+1}  = 'PV';
              obj.Comp.prop(ncomp+1,:) = [2 1 0 1 0 1 0 0 0];
              obj.Comp.names{ncomp+2}  = 'SW';
              obj.Comp.prop(ncomp+2,:) = [2 1 0 1 0 1 0 0 0];
              obj.Comp.n = ncomp + 2;
            end

            if ~command_line_psat
              set(hdlp,'XData',[8 8 206 206 8])
              set(htxt,'String','Initializing global structures...')
              drawnow
            end
            
            if ~isunix && obj.Settings.hostver >= 7 && sum(obj.Theme.color09) < 0.3
              obj.Theme.color09 = [0 0 0];
            end

            % Differential Algebraic Equations structure
            obj.DAE = struct('x',[], ...
                         'y',[], ...
                         'kg',0, ...
                         'lambda',0, ...
                         'm',0, ...
                         'n',0, ...
                         'npf',0, ...
                         'g',[], ...
                         'f',[], ...
                         'Gy',[], ...
                         'Fx',[], ...
                         'Fy',[], ...
                         'Fl',[], ...
                         'Fk',[], ...
                         'Gx',[], ...
                         'Gl',[], ...
                         'Gk',[], ...
                         'Ac',[], ...
                         'tn',[], ...
                     't', -1);

            % Small Signal Stability Analysis (SSSA) paramters
            obj.SSSA = struct('neig',1,'method',1,'map',1,'matrix',4, ...
                          'report',[],'eigs',[],'pf',[]);

            % Limit-induced bifurcation (LIB) parameters
            obj.LIB = struct('type',1,'init',0,'selbus',1, ...
                         'slack',0,'lambda',0,'dldp',[],'bus',[]);

            % Saddle-node bifurcation (SNB) parameters
            obj.SNB = struct('slack',0,'init',0,'lambda',0,'dldp',[],'bus',[]);

            % Continuation Power Flow structure
            obj.CPF = struct('method',1,'flow',1,'type',1,'sbus',1, ...
                         'vlim',0,'ilim',0,'qlim',0,'init',0, ...
                         'tolc',1e-5,'tolf',0.01,'tolv',5e-3, ...
                         'step',0.5,'nump',50,'show',1,'linit',0, ...
                         'lambda',0,'kg',0,'hopf',0,'stepcut',1,...
                         'negload',0,'onlynegload',0,'onlypqgen',0, ...
                         'areaannualgrowth',0,'regionannualgrowth',0);

                     % Optimal Power Flow structure
            obj.OPF = struct('method',2, ...
                         'flow',1, ...
                         'type',1, ...
                         'deltat',30, ...
                         'lmin',0.1, ...
                         'lmax',0.8, ...
                         'sigma',0.2, ...
                         'gamma',0.95, ...
                         'eps_mu',1e-10, ...
                         'eps1',1e-4, ...
                         'eps2',5e-3, ...
                         'omega',0, ...
                         'omega_s','0', ...
                         'lmin_s','0.1', ...
                         'fun','', ...
                         'flatstart',1, ...
                         'conv',0, ...
                         'guess',[], ...
                         'report',[], ...
                         'show',1, ...
                         'init',0, ...
                         'w',0, ...
                         'wp',[], ...
                         'atc',0, ...
                         'line',0, ...
                         'tiebreak',0, ...
                         'basepg',1, ...
                         'basepl',1, ...
                         'enflow',1, ...
                         'envolt',1, ...
                         'enreac',1, ...
                         'vmin', 0.8, ...
                         'vmax', 1.2, ...
                         'obj',0, ...
                         'ms',0, ...
                         'dy',0, ...
                         'dF',0, ...
                         'dG',0, ...
                         'LMP',[], ...
                         'NCP',[], ...
                         'iter',0, ...
                         'gpc',[], ...
                         'gqc',[]);

            obj.OMIB = struct('cm',[],'ncm',[],'mt',[],'pmax',[],'pc',[], ...
                          'sig',[],'du',[],'tu',[],'margin',0);

            obj.PMU = struct('method',1, ...
                         'number',0, ...
                         'report','', ...
                         'measv',0, ...
                         'measc',0, ...
                         'pseudo',0, ...
                         'noobs',0, ...
                         'voltage', '', ...
                         'angle', '', ...
                         'location', '');
            % GAMS interface structure
            obj.GAMS = struct('method',2, ...
                          'type',1, ...
                          'flow',1, ...
                          'flatstart',1, ...
                          'lmin', 0.1, ...
                          'lmin_s','0.1', ...
                          'omega',0, ...
                          'omega_s','0', ...
                          'lmax',0.8, ...
                          'libinclude', 0, ...
                          'loaddir',1, ...
                          'basepl',1, ...
                          'basepg',1, ...
                          'line',0, ...
                          'show',1);

            obj.GAMS.ldir = ['ldir ',char(92),'~/psat/gams'];

            % UWPFLOW interface
            obj.UWPFLOW = struct('opt',[],'method',1,'file','psatuw', ...
                             'command','','status',0);

            % Structure for libraries
            obj.LA = struct( ...
                'a',[], ...
                'b_avr',[], 'b_tg',[], 'b_svc',[], 'b_statcom',[], ...
                'b_tcsc',[], 'b_sssc',[], 'b_upfc',[], 'b_hvdc',[], ...
                'c_y',[], ...
                'd_y',[], ...
                'd_avr',[], 'd_tg',[], 'd_svc',[], 'd_statcom',[], ...
                'd_tcsc',[], 'd_sssc',[], 'd_upfc',[], 'd_hvdc',[], ...
                'h_ps',[], 'h_qs',[], 'h_is',[], 'h_pr',[], 'h_qr',[], 'h_ir',[]);
            obj.EQUIV = struct( ...
                'buslist',[], ...
                'custom_file','', ...
                'custom_path','', ...
                'equivalent_method',1, ...
                'area_num',1, ...
                'region_num',1, ...
                'bus_selection',1, ...
                'bus_depth',0, ...
                'bus_voltage',220, ...
                'island', 0, ...
                'gentype', 1, ...
                'stop_island',0);

            if ~command_line_psat
              set(hdlp,'XData',[8 8 239 239 8])
              set(htxt,'String','Initializing classes...')
              drawnow
            end
% THESE SHOULD BE SUBCLASSED
            % Component classes & structures
            obj.Bus = BUclass(obj);
            obj.Areas = ARclass(obj,'area');
            obj.Regions = ARclass(obj,'region');
            obj.SW = SWclass(obj);
            obj.PV = PVclass(obj);
            obj.PQ = PQclass(obj);
            obj.Line = LNclass(obj);
            obj.Lines = LSclass(obj);
            obj.Twt = TWclass(obj);
            obj.Shunt = SHclass(obj);
            obj.PQgen = PQclass(obj);
            obj.Demand = DMclass(obj);
            obj.Supply = SUclass(obj);
            obj.Fault = FTclass(obj);
            obj.Breaker = BKclass(obj);
            obj.Fl = FLclass(obj);

            if ~command_line_psat
              set(hdlp,'XData',[8 8 272 272 8])
              drawnow
            end

            obj.Mn = MNclass(obj);
            obj.Pl = PLclass(obj);
            obj.Ind = IMclass(obj);
            obj.Thload = THclass(obj);
            obj.Ltc = LTclass(obj);
            obj.Tap = TPclass(obj);
            obj.Syn = SYclass(obj);
            obj.Exc = AVclass(obj);
            obj.Tg = TGclass(obj);
            obj.Oxl = OXclass(obj);
            obj.Pss = PSclass(obj);
            obj.Svc = SVclass(obj);
            obj.Statcom = STclass(obj);
            obj.Tcsc = TCclass(obj);
            obj.Sssc = SSclass(obj);
            obj.Upfc = UPclass(obj);
            obj.Hvdc = HVclass(obj);
            
            
            if ~command_line_psat
              set(hdlp,'XData',[8 8 305 305 8])
              drawnow
            end

            obj.Mass = DSclass(obj);
            obj.SSR = SRclass(obj);
            obj.Rmpg = RGclass(obj);
            obj.Rmpl = RLclass(obj);
            obj.Rsrv = RSclass(obj);
            obj.Vltn = VLclass(obj);
            obj.Ypdp = YPclass(obj);
            obj.Pod = POclass(obj);
            obj.COI = CIclass(obj);
            
% REMOVE SIMULINK FOR BETTER PERFORMANCE?
            if ~command_line_psat
              set(hdlp,'XData',[8 8 338 338 8])
              set(htxt,'String','Initializing Simulink Library...')
              drawnow
            end

            % load PSAT Simulink library
%             if obj.Settings.matlab && obj.Settings.hostver >= 7
%               if ~exist('load_system')  %#ok
%                 if exist('simulink') ~= 5 %#ok
% %% SCRIPT FM_DISP
%                   obj.fm_disp('* * Simulink cannot be found on your system.')
%                   obj.fm_disp('* * The PSAT-Simulink will not be available.')
%                 else
%                   obj.fm_disp('* * Problems in loading the PSAT Simulink Library.')
%                 end
%               else
%                 load_system('fm_lib')   % built-in
%               end
%             end
% 
%             if failed
%               disp(' '), disp('PSAT is not properly initialized.')
%             else
%% SCRIPT fm_main
%                 if ~command_line_psat, fm_main, end
%             end

            if ~command_line_psat, close(hdl), end

            clear failed hdl hdlp a count fid nname sline tipi ncomp
            clear psatver psatdate psatdir lipdir command_line_psat htxt
            
            % ----------------------------------------------------------- %
            %                       W A R N I N G                         %
            % ----------------------------------------------------------- %
            % Following lines were written by the UDM build utility.      %
            % This utility requires you do NOT change anything beyond     %
            % this point in order to be able to correctly install and     %
            % uninstall UDMs.                                             %
            % ----------------------------------------------------------- %

            obj.Sofc = FCclass(obj);
            obj.Cac = CCclass(obj);
            obj.Cluster = CLclass(obj);
            obj.Exload = ELclass(obj);
            obj.Phs = PHclass(obj);
            obj.Wind = WNclass(obj);
            obj.Cswt = CSclass(obj);
            obj.Dfig = DFclass(obj);
            obj.Ddsg = DDclass(obj);
            obj.Busfreq = BFclass(obj);
            obj.Pmu = PMclass(obj);
            obj.Jimma = JIclass(obj);
            obj.Mixload = MXclass(obj);
            obj.WTFR = WTFRclass(obj);
            obj.Spv = SPVclass(obj);
            obj.Spq = SPQclass(obj);

         % CONSTRUCTOR END < 
        end
        
        
    end
    %% Real methods
    methods
       settings(obj)    % changes Settings and Theme properties
       
       output = fm_disp(obj,varargin) %  Fig History Hdl Settings Theme clpsat
       
       runpsat(obj,varargin)    % Settings File Path clpsat
       % now this method is a real mess. It does not
       % serve a single purpose a multitude...
       
       % FM_MAIN should never be ran since I will use PSAT only through CLI
       fig = fm_main(obj,varargin)  % Settings Path File History Hdl Theme Fig
       %  Solve power flow
       fm_spf(obj) %DAE Pl Mn Lines Line SW PV PQ Bus
       % History Theme Fig Settings LIB Snapshot Path File
       %% Functions neccessary for spf -> solve power flow
       fm_ncomp(obj)
       fm_base(obj) % execute base() of all subclass
       fm_errv(Vold,msg,busidx,psat_obj)
       fm_wcall(obj)
       
       fm_call(obj,flag) % THIS IS !!!
    
       fm_dynlf(obj)
       fm_status(obj,varargin)   
       fm_setgy(obj,varargin)
       fm_dynidx(obj)
       fm_idx(obj,flag)
       % Small Signal Stability
       fm_abcd(obj) % LA DAE Exc Tg Line Svc Tcsc Statcom Sssc Upfc Hvdc
       
       % File readers
       readPsatFile(obj,fileName) % Read PSAT data file and assign values
       %    to PSAT instance
    end
    methods (Static)
        [fig,ht] = fm_enter(upath,psatver,psatdate)
    end
end
