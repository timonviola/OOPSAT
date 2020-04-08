function fm_inilf(obj)
% FM_INILF initialize all system and component variables
%          for power flow computations
%
% FM_INILF
%
%see also FM_SLF
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    22-Feb-2003
%Update:    09-Jul-2003
%Version:   1.0.2
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

% global DAE Settings OPF LIB SNB Varname Varout SSSA PMU clpsat Snapshot
% global Bus Areas Regions Shunt SW PV PQ PQgen Line Lines Twt Fl Mn
% global Demand Supply Pl Syn Mass Exc Fault Breaker Ind Thload Tg COI
% global Ltc Tap Oxl Pss Mass SSR Svc Statcom Tcsc Sssc Upfc Hvdc Pod
% global Rmpg Rmpl Rsrv Vltn Ypdp Sofc Cac Cluster Exload Phs Wind Cswt
% global Dfig Ddsg Busfreq Mixload Jimma Pmu WTFR Spv Spq

% Deleting Self-generated functions
clear fm_call

% General Variables
obj.DAE.kg = 0;
obj.DAE.lambda = 0;
obj.Settings.iter = 0;
obj.Settings.nseries = 0;
obj.Settings.error = obj.Settings.lftol+1;

% OPF, CPF, LIB & SNB variables
obj.OPF.report = [];
obj.OPF.init = 0;
obj.OPF.line = 0;
obj.CPF.init = 0;
obj.LIB.lambda = 0;
obj.LIB.dldp = [];
obj.LIB.bus = [];
obj.LIB.init = 0;
obj.SNB.lambda = 0;
obj.SNB.dldp = [];
obj.SNB.bus = [];
obj.SNB.init = 0;

% Variable Name Structure
obj.Varname.uvars = '';
obj.Varname.fvars = '';
obj.Varname.nvars = 0;
obj.Varname.idx = [];
obj.Varname.pos = [];
obj.Varname.areas = 0;
obj.Varname.regions = 0;

% Output variables
obj.Varout.t = [];
obj.Varout.vars = [];
obj.Varout.idx = [];
obj.Varout.surf = 0;
obj.Varout.movie = [];
obj.Varout.xb = [];
obj.Varout.yb = [];

% Snapshot
obj.Snapshot = struct( ...
    'name','', ...
    'time',obj.Settings.t0, ...
    'y',[], ...
    'x', [], ...
    'Ybus', [], ...
    'Pg', [], ...
    'Qg', [], ...
    'Pl', [], ...
    'Ql', [], ...
    'Gy', [], ...
    'Fx', [], ...
    'Fy', [], ...
    'Gx', [], ...
    'Ploss', [], ...
    'Qloss', [], ...
    'it', 0);

% Numbers
obj.DAE.m = 0;
obj.DAE.n = 0;
obj.DAE.npf = 0;

% Time
obj.DAE.t = -1;

% Vectors
obj.DAE.x = [];
obj.DAE.y = [];
obj.DAE.g = [];
obj.DAE.f = [];

% Jacobians
obj.DAE.Gy = [];
obj.DAE.Gx = [];
obj.DAE.Gl = [];
obj.DAE.Gk = [];
obj.DAE.Fx = [];
obj.DAE.Fy = [];
obj.DAE.Fl = [];
obj.DAE.Fk = [];

% small signal stability analysis parameters
obj.SSSA.pf = [];
obj.SSSA.eigs = [];
obj.SSSA.report = [];

% Phasor Measurment Units
obj.PMU.number = 0;
obj.PMU.voltage = '';
obj.PMU.angle = '';
obj.PMU.location = '';
obj.PMU.report = '';
obj.PMU.measv = 0;
obj.PMU.measc = 0;
obj.PMU.pseudo = 0;
obj.PMU.noobs = 0;

% initialize components     %% now this is a good questions if its gonna work or not
obj.Bus = init(obj.Bus);
obj.Areas = init(obj.Areas);
obj.Regions = init(obj.Regions);
obj.Shunt = init(obj.Shunt);
obj.SW = init(obj.SW);
obj.PV = init(obj.PV);
obj.PQ = init(obj.PQ);
obj.PQgen = init(obj.PQgen);
obj.Line = init(obj.Line);
obj.Lines = init(obj.Lines);
obj.Twt = init(obj.Twt);
obj.Fl = init(obj.Fl);
obj.Demand = init(obj.Demand);
obj.Supply = init(obj.Supply);
obj.Mn = init(obj.Mn);
obj.Pl = init(obj.Pl);
obj.Syn = init(obj.Syn);
obj.Mass = init(obj.Mass);
obj.Exc = init(obj.Exc);
obj.Fault = init(obj.Fault);
obj.Breaker = init(obj.Breaker);
obj.Ind = init(obj.Ind);
obj.Thload = init(obj.Thload);
obj.Tg = init(obj.Tg);
obj.COI = init(obj.COI);
obj.Ltc = init(obj.Ltc);
obj.Tap = init(obj.Tap);
obj.Oxl = init(obj.Oxl);
obj.Pss = init(obj.Pss);
obj.Mass = init(obj.Mass);
obj.SSR = init(obj.SSR);

% FACTS
obj.Svc = init(obj.Svc);
obj.Statcom = init(obj.Statcom);
obj.Tcsc = init(obj.Tcsc);
obj.Sssc = init(obj.Sssc);
obj.Upfc = init(obj.Upfc);
obj.Hvdc = init(obj.Hvdc);
obj.Pod = init(obj.Pod);

% Market data
obj.Rmpg = init(obj.Rmpg);
obj.Rmpl = init(obj.Rmpl);
obj.Rsrv = init(obj.Rsrv);
obj.Vltn = init(obj.Vltn);
obj.Ypdp = init(obj.Ypdp);

% ----------------------------------------------------------- %
%                       W A R N I N G                         %
% ----------------------------------------------------------- %
% Following lines have been written by the UDM build utility. %
% This utility requires you do NOT change anything beyond     %
% this point in order to be able to correctly install and     %
% uninstall UDMs.                                             %
% ----------------------------------------------------------- %

obj.Sofc = init(obj.Sofc);

obj.Cac = init(obj.Cac);
obj.Cluster = init(obj.Cluster);

obj.Exload = init(obj.Exload);
obj.Phs = init(obj.Phs);

obj.Wind = init(obj.Wind);
obj.Cswt = init(obj.Cswt);
obj.Dfig = init(obj.Dfig);
obj.Ddsg = init(obj.Ddsg);

obj.Busfreq = init(obj.Busfreq);
obj.Pmu = init(obj.Pmu);
obj.Mixload = init(obj.Mixload);
obj.Jimma = init(obj.Jimma);
obj.WTFR = init(obj.WTFR);
obj.Spv = init(obj.Spv);
obj.Spq = init(obj.Spq);
