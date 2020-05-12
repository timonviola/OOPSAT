function fm_restore(obj)
% FM_RESTORE reset all component data using the "store" field
%
% FM_RESTORE
%
%see also RUNPSAT
%
%Author:    Federico Milano
%Update:    13-Jun-2008
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

obj.fm_inilf

obj.Bus = restore(obj.Bus,obj);
obj.Line = restore(obj.Line,obj);
obj.Lines = restore(obj.Lines,obj);
obj.Twt = restore(obj.Twt,obj);
obj.Shunt = restore(obj.Shunt,obj);
obj.Fault = restore(obj.Fault,obj);
obj.Breaker = restore(obj.Breaker,obj);
obj.PV = restore(obj.PV,obj);
obj.SW = restore(obj.SW,obj);
obj.Areas = restore(obj.Areas,obj);
obj.Regions = restore(obj.Regions,obj);
obj.PQgen = restore(obj.PQgen,0,obj);
obj.PQ = restore(obj.PQ,obj);
obj.Pl = restore(obj.Pl,obj);
obj.Mn = restore(obj.Mn,obj);
obj.Fl = restore(obj.Fl,obj);
obj.Ind = restore(obj.Ind,obj);
obj.Thload = restore(obj.Thload,obj);
obj.Tap = restore(obj.Tap,obj);
obj.Syn = restore(obj.Syn,obj);
obj.Exc = restore(obj.Exc,obj);
obj.Tg = restore(obj.Tg,obj);
obj.Oxl = restore(obj.Oxl,obj);
obj.Pss = restore(obj.Pss,obj);
obj.Ltc = restore(obj.Ltc,obj);
obj.Svc  = restore(obj.Svc,obj);
obj.Statcom = restore(obj.Statcom,obj);
obj.Tcsc = restore(obj.Tcsc,obj);
obj.Sssc = restore(obj.Sssc,obj);
obj.Upfc = restore(obj.Upfc,obj);
obj.Hvdc = restore(obj.Hvdc,obj);
obj.Demand = restore(obj.Demand,obj);
obj.Supply = restore(obj.Supply,obj);
obj.Rmpg = restore(obj.Rmpg,obj);
obj.Rmpl = restore(obj.Rmpl,obj);
obj.Rsrv = restore(obj.Rsrv,obj);
obj.Vltn = restore(obj.Vltn,obj);
obj.Ypdp = restore(obj.Ypdp,obj);
obj.Mass = restore(obj.Mass,obj);
obj.SSR = restore(obj.SSR,obj);
obj.Pod = restore(obj.Pod,obj);
obj.COI = setup(obj.COI,obj);

% ----------------------------------------------------------- %
%                       W A R N I N G                         %
% ----------------------------------------------------------- %
% Following lines were written by the UDM build utility.      %
% This utility requires you do NOT change anything beyond     %
% this point in order to be able to correctly install and     %
% uninstall UDMs.                                             %
% ----------------------------------------------------------- %

obj.Sofc = restore(obj.Sofc,obj);
obj.Cac = restore(obj.Cac,obj);
obj.Cluster = restore(obj.Cluster,obj);
obj.Exload = restore(obj.Exload,obj);
obj.Phs = restore(obj.Phs,obj);
obj.Wind = restore(obj.Wind,obj);
obj.Cswt = restore(obj.Cswt,obj);
obj.Dfig = restore(obj.Dfig,obj);
obj.Ddsg = restore(obj.Ddsg,obj);
obj.Busfreq = restore(obj.Busfreq,obj);
obj.Pmu = restore(obj.Pmu,obj);
obj.Jimma = restore(obj.Jimma,obj);
obj.Mixload = restore(obj.Mixload,obj);
obj.WTFR = restore(obj.WTFR,obj);
obj.Spv = restore(obj.Spv,obj);
obj.Spq = restore(obj.Spq,obj);
