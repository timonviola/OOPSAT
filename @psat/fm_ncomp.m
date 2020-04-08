function fm_ncomp(obj)
% FM_NCOMP search components used in the current data
%          file and initializes fields used for power
%          flow computations.
%
% CHECK = FM_NCOMP
%
%see also FM_SLF
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    22-Feb-2003
%Version:   1.0.1
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

% global Settings
% global Bus Areas Regions Shunt SW PV PQ PQgen Line Lines Twt Fl Mn
% global Demand Supply Pl Syn Mass Exc Fault Breaker Ind Thload Tg COI
% global Ltc Tap Oxl Pss Mass SSR Svc Statcom Tcsc Sssc Upfc Hvdc Pod
% global Rmpg Rmpl Rsrv Vltn Ypdp Sofc Cac Cluster Exload Phs Wind Cswt
% global Dfig Ddsg Busfreq Mixload Jimma Pmu WTFR Spv Spq

obj.Settings.ok = 1;

% setup components
obj.Bus = setup(obj.Bus,    obj);
obj.Line = setup(obj.Line,  obj);
obj.Lines = setup(obj.Lines,obj);
obj.Twt = setup(obj.Twt,    obj);
obj.Shunt = setup(obj.Shunt,obj);
obj.Fault = setup(obj.Fault,obj);
obj.Breaker = setup(obj.Breaker,obj);
obj.PV = setup(obj.PV,      obj);
obj.SW = setup(obj.SW,      obj);

obj.Areas = setup(obj.Areas,obj);

obj.Regions = setup(obj.Regions,obj);
obj.PQ = setup(obj.PQ,      obj);
obj.PQgen = setup(obj.PQgen,obj);

obj.PQ = addgen(obj.PQ,obj.PQgen,obj);

obj.Pl = setup(obj.Pl,      obj);
obj.Mn = setup(obj.Mn,      obj);
obj.Fl = setup(obj.Fl,      obj);
obj.Ind = setup(obj.Ind,    obj);
obj.Thload = setup(obj.Thload,obj);
obj.Tap = setup(obj.Tap,    obj);
obj.Syn = setup(obj.Syn,    obj);
obj.Exc = setup(obj.Exc,    obj);
obj.Tg = setup(obj.Tg,      obj);
obj.Oxl = setup(obj.Oxl,    obj);
obj.Pss = setup(obj.Pss,    obj);
obj.Ltc = setup(obj.Ltc,    obj);
obj.Svc  = setup(obj.Svc,   obj);
obj.Statcom = setup(obj.Statcom,obj);
obj.Tcsc = setup(obj.Tcsc,  obj);
obj.Sssc = setup(obj.Sssc,  obj);
obj.Upfc = setup(obj.Upfc,  obj);
obj.Hvdc = setup(obj.Hvdc,  obj);
obj.Demand = setup(obj.Demand,obj);
obj.Supply = setup(obj.Supply,obj);
obj.Rmpg = setup(obj.Rmpg,  obj);
obj.Rmpl = setup(obj.Rmpl,  obj);
obj.Rsrv = setup(obj.Rsrv,  obj);
obj.Vltn = setup(obj.Vltn,  obj);
obj.Ypdp = setup(obj.Ypdp,  obj);
obj.Mass = setup(obj.Mass,  obj);
obj.SSR = setup(obj.SSR,    obj);
obj.Pod = setup(obj.Pod,    obj);
obj.COI = setup(obj.COI,    obj);

% ----------------------------------------------------------- %
%                       W A R N I N G                         %
% ----------------------------------------------------------- %
% Following lines have been written by the UDM build utility. %
% This utility requires you do NOT change anything beyond     %
% this point in order to be able to correctly install and     %
% uninstall UDMs.                                             %
% ----------------------------------------------------------- %

obj.Sofc = setup(obj.Sofc,obj);
obj.Cac = setup(obj.Cac,obj);
obj.Cluster = setup(obj.Cluster,obj);
obj.Exload = setup(obj.Exload,obj);
obj.Phs = setup(obj.Phs,obj);
obj.Wind = setup(obj.Wind,obj);
obj.Cswt = setup(obj.Cswt,obj);
obj.Dfig = setup(obj.Dfig,obj);
obj.Ddsg = setup(obj.Ddsg,obj);
obj.Busfreq = setup(obj.Busfreq,obj);
obj.Pmu = setup(obj.Pmu,obj);
obj.Jimma = setup(obj.Jimma,obj);
obj.Mixload = setup(obj.Mixload,obj);
obj.WTFR = setup(obj.WTFR,obj);
obj.Spv = setup(obj.Spv,obj);
obj.Spq = setup(obj.Spq,obj);
