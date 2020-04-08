function runpsat(obj, varargin)
% RUNPSAT run PSAT routine for power system analysis
%
% RUNPSAT([FILE,[PATH]],[PERTFILE,[PERTPATH]],ROUTINE)
%
%   FILE:     string containing the PSAT data file (can be a
%             simulink model)
%   PATH:     string containing the absolute path of the data
%             file (default path is "pwd")
%   PERTFILE: string containing the PSAT perturbation file
%             (default is the empty string)
%   PERTPATH: string containing the absolute path of the
%             perturbation file (default is the empty string)
%   ROUTINE:  name of the routine to be launched:
%
%     General options:
%
%       'data'    => set data file
%       'pert'    => set perturbation file
%       'opensys' => open saved system
%       'savsys'  => save currenst system
%       'pfrep'   => write power flow solution
%       'eigrep'  => write eigenvalue report file
%       'pmurep'  => write PMU placement report file
%       'plot'    => plot TD results (Octave only)
%
%     Routines:
%
%       'pf'      => power flow
%       'cpf'     => continuation power flow
%       'snb'     => SNB computation (direct method)
%       'limit'   => LIB computation
%       'n1cont'  => N-1 contingency analysis
%       'opf'     => optimal power flow
%       'cpfatc'  => ATC computation through CPF analysis
%       'sensatc' => ATC computation through sensitivity
%                    analysis
%       'td'      => time domain simulation
%       'sssa'    => small signal stability analysis
%       'pmu'     => PMU placement
%       'gams'    => OPF through PSAT-GAMS interface
%       'uw'      => CPF through PSAT-UWPFLOW interface
%
%Author:    Federico Milano
%Date:      23-Feb-2004
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano



routine = varargin{nargin-1};
if isnumeric(routine)
  obj.fm_disp('Routine specifier must be a string.')
  return
end

% Simulink models are not supported on GNU/Octave
if obj.Settings.octave && strcmp(routine,'data') && ...
      ~isempty(findstr(varargin{1},'.mdl'))
  obj.fm_disp('Simulink models are not supported on GNU/Octave')
  return
end

% check if the data file has been changed
changedata = strcmp(routine,'data');
if nargin > 1
  changedata = changedata || ~strcmp(varargin{1},obj.File.data);
end

if changedata, obj.Settings.init = 0; end

% check inputs
switch (nargin-1) % obj --> +1
 case 5
  obj.File.data = varargin{1};
  obj.Path.data = checksep(varargin{2});
  obj.File.pert = varargin{3};
  obj.Path.pert = checksep(varargin{4});
 case 4
  obj.File.data = varargin{1};
  obj.Path.data = checksep(varargin{2});
  obj.File.pert = varargin{3};
  obj.Path.pert = [pwd,filesep];
 case 3
  switch routine
   case 'data'
    obj.File.data = varargin{1};
    obj.Path.data = checksep(varargin{2});
   case 'pert'
    obj.File.pert = varargin{1};
    obj.Path.pert = checksep(varargin{2});
   case 'opensys'
    datafile = varargin{1};
    datapath = checksep(varargin{2});
   otherwise
    obj.File.data = varargin{1};
    obj.Path.data = checksep(varargin{2});
    obj.File.pert = '';
    obj.Path.pert = '';
  end
 case 2
  switch routine
   case 'data'
    obj.File.data = varargin{1};
    obj.Path.data = [pwd,filesep]; % TODO: This better be changed since pwd causes unexpected shit!!!!!
   case 'pert'
    obj.File.pert = varargin{1};
    obj.Path.pert = [pwd,filesep];
   case 'opensys'
    datafile = varargin{1};
    datapath = [pwd,filesep];
   case 'plot'
    % nothing to do...
   otherwise
    obj.File.data = varargin{1};
    obj.Path.data = [pwd,filesep];
    obj.File.pert = '';
    obj.Path.pert = '';
  end
 case 1
  % nothing to do...
 otherwise
  obj.fm_disp('Invalid number of arguments: check synthax...')
  return
end
%% ====== END OF INPUT PARSING =====

% remove extension from data file (only Matlab files)
if length(obj.File.data) >= 2 && strcmp(routine,'data')
  if strcmp(obj.File.data(end-1:end),'.m')
    obj.File.data = obj.File.data(1:end-2);
  end
end

% remove extension from perturbation file (only Matlab files)
if length(obj.File.pert) >= 2 && strcmp(routine,'pert')
  if strcmp(obj.File.pert(end-1:end),'.m')
    obj.File.pert = obj.File.pert(1:end-2);
  end
end

% set local path as data path to prevent undesired change
% of path within user defined functions
obj.Path.local = obj.Path.data;

% check if the data file is a Simulink model
obj.File.data = strrep(obj.File.data,'.mdl','(mdl)');

if ~isempty(findstr(obj.File.data,'(mdl)'))
  filedata = deblank(strrep(obj.File.data,'(mdl)','_mdl'));
  if exist(filedata) ~= 2 || obj.clpsat.refreshsim || strcmp(routine,'data')
% % CALL SIM2PSAT
    check = sim2psat;
    if ~check, return, end
    obj.File.data = filedata;
  end
end


%% ====== START ======
% launch PSAT computations
switch routine
 case 'data' % set data file
  % checking the consistency of the data file
  localpath = pwd; % TODO:  eliminate pwd
  cd(obj.Path.data)
  check = exist(obj.File.data);
  cd(localpath)
  if check ~= 2 && check ~= 4
    % obj.fm_disp(['Warning: The selected file is not valid or not in the ' ...
    %          'current folder!'])
    error('PSAT:inputFile',['The selected file is not valid or not in ' ...
            'the current folder!'])
  else
    obj.Settings.init = 0;
  end
  % After all this is called 'data' but in fact it does not load the data file, 
  % it barely sets the data file paths. Probably the data load is done during
  % power-flow execution.



  %% The rest doesnt matter for now as it is considered unimplemented
 case 'pert' % set perturbation file
  localpath = pwd;
  cd(obj.Path.pert)
  check = exist(obj.File.pert);
  cd(localpath)
  % checking the consistency of the pert file
  if check ~= 2
%     obj.fm_disp(['Warning: The selected file is not valid or not in the ' ...
%              'current folder!'])
    error('PSAT:inputFile',['The selected file is not valid or not in ' ...
            'the current folder!'])
  else
    localpath = pwd;
    cd(obj.Path.pert)
    if obj.Settings.hostver >= 6
      Hdl.pert = str2func(obj.File.pert);
    else
      Hdl.pert = obj.File.pert;
    end
    cd(localpath)
  end
 case 'opensys'
  fm_set('opensys',datafile,datapath)
  obj.Settings.init = 0;
 case 'savesys'
  fm_set('savesys')
 case 'log'
  fm_text(1)
 case 'pfrep'
  fm_report
 case 'eigrep'
  fm_eigen('report')

  %% This I need
 case 'pf'   % solve power flow

  if isempty(obj.File.data)
    obj.fm_disp('Set a data file before running Power Flow.',2)
    return
  end

  %% File reading
  if obj.clpsat.readfile || obj.Settings.init == 0
    % If MATPOWER is to be used: all data should be passed at this point and nothing executing after this
%% SCRIPT call fm_inilf
    obj.fm_inilf

    filedata = [obj.File.data,'  '];
    filedata = strrep(filedata,'@ ','');

    if ~isempty(findstr(filedata,'(mdl)')) && obj.clpsat.refreshsim
      filedata1 = obj.File.data(1:end-5);
      open_sys = find_system('type','block_diagram');
      OpenModel = sum(strcmp(open_sys,filedata1));
      if OpenModel
        if strcmp(get_param(filedata1,'Dirty'),'on') || ...
              str2num(get_param(filedata1,'ModelVersion')) > obj.Settings.mv
          check = sim2psat;
          if ~check, return, end
        end
      end
    end
    cd(obj.Path.data)
    filedata = deblank(strrep(filedata,'(mdl)','_mdl'));
    a = exist(filedata);
    clear(filedata)
    if a == 2,
      b = dir([filedata,'.m']);
      lasterr('');
      %if ~strcmp(obj.File.modify,b.date)
      try
        obj.fm_disp('Load data from file...')
        %% Read data file
% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        obj.readPsatFile(filedata)%TODO: add support to different file formats
% $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        %%
        obj.File.modify = b.date;
      catch
        obj.fm_disp(lasterr),
        obj.fm_disp(['Something wrong with the data file "',filedata,'"']),
        return
      end
      %end
    else
      obj.fm_disp(['obj.File "',filedata,'" not found or not an m-file'],2)
    end
    cd(obj.Path.local)
    obj.Settings.init = 0;
  end

  if obj.Settings.init
    fm_restore
    if obj.Settings.conv, fm_base, end
    obj.Line = build_y(obj.Line);
    fm_wcall;
    fm_dynlf;
  end

  filedata = deblank(strrep(obj.File.data,'(mdl)','_mdl'));
  if obj.Settings.static % do not use dynamic components
    for i = 1:Comp.n
      comp_name = [Comp.names{i},'.con'];
      comp_con = eval(['~isempty(',comp_name,')']);
      if comp_con && ~Comp.prop(i,6)
        eval([comp_name,' = [];']);
      end
    end
  end

  % the following code is needed for compatibility with older PSAT versions
  if isfield(obj.Varname,'bus')
    if ~isempty(obj.Varname.bus)
      obj.Bus.names = obj.Varname.bus;
      obj.Varname = rmfield(obj.Varname,'bus');
    end
  end

  if exist('Mot')
    if isfield(Mot,'con')
      obj.Ind.con = obj.Mot.con;
      clear Mot
    end
  end
%% SCRIPT CALL FM_SPF
  obj.fm_spf
  obj.SNB.init = 0;
  obj.LIB.init = 0;
  obj.CPF.init = 0;
  obj.OPF.init = 0;

 case 'opf'  % solve optimal power flow
  fm_set('opf')
 case 'cpf'  % solve continuation power flow
  fm_cpf('main');
 case 'cpfatc'  % find ATC of the current system
  opftype = OPF.type;
  OPF.type = 4;
  fm_atc
  OPF.type = opftype;
 case 'sensatc'
  opftype = OPF.type;
  OPF.type = 5;
  fm_atc
  OPF.type = opftype;
 case 'n1cont'
  fm_n1cont;
 case 'td'   % solve time domain simulation
  fm_int
 case 'sssa' % solve small signal stability analyisis
  fm_eigen('runsssa')
 case 'snb'
  fm_snb

 case 'lib'
  fm_limit

 case 'pmu'
  fm_pmuloc;

 case 'pmurep'
  fm_pmurep;

 case 'gams' % solve OPF using the PSAT-GAMS interface
  fm_gams

 case 'uw'   % solve CPF using the PSAT-UWPFLOW interface
  fm_uwpflow('init')
  fm_uwpflow('uwrun')

 case 'plot'
  if ~obj.Settings.octave
    obj.fm_disp('This option is supported only on GNU/Octave')
    return
  end
  if isempty(Varout.t)
    obj.fm_disp('No data is available for plotting')
    return
  end
  if nargin == 2
    value = varargin{1};
  else
    value = menu('Plot variables:','States','Voltage Magnitudes', ...
                 'Voltage Angles','Active Powers','Reactive Powers', ...
                 'Generator Speeds','Generator Angles');
  end

  switch value
   case 1
    if ~DAE.n
      obj.fm_disp('No dynamic component is loaded')
      return
    end
   case {2,3,4,5}
    if ~Bus.n
      obj.fm_disp('No bus is present in the current network')
      return
    end
   case {6,7}
    if ~Syn.n
      obj.fm_disp('No synchronous generator is loaded')
      return
    end
  end



  switch value
   case 1
    idx = intersect([1:DAE.n],Varname.idx);
   case 2
    idx0 = DAE.n+Bus.n;
    idx = intersect([idx0+1:idx0+Bus.n],Varname.idx);
   case 3
    idx0 = DAE.n;
    idx = intersect([idx0+1:idx0+Bus.n],Varname.idx);
   case 4
    idx0 = DAE.n+DAE.m;
    idx = intersect([idx0+1:idx0+Bus.n],Varname.idx);
   case 5
    idx0 = DAE.n+DAE.m+Bus.n;
    idx = intersect([idx0+1:idx0+Bus.n],Varname.idx);
   case 6
    idx = intersect(Syn.omega,Varname.idx);
   case 7
    idx = intersect(Syn.delta,Varname.idx);
  end

  if isempty(idx)
    obj.fm_disp('The selected data have not been stored.')
    return
  end

  n = length(idx);
  y = Varout.vars(:,idx);
  s = Varname.uvars(idx);

  plot(Varout.t,y(:,1),['1;',strrep(s{1},'_',' '),';'])
  hold on
  for i = 2:n
    FMT = [num2str(rem(i-1,6)+1),';',strrep(s{i},'_',' '),';'];
    plot(Varout.t,y(:,i),FMT)
  end
  xlabel(obj.Settings.xlabel)
  hold off

 otherwise   % give an error message and exit

  obj.fm_disp(['"',routine,'" is an invalid routine identifier.'])
  return

end

% ----------------------------------------------------------------
function string = checksep(string)

if ~strcmp(string(end),filesep)
  string = [string,filesep];
end
