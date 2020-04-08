function fm_base(obj)
%FM_BASE report component parameters to system bases
%
%FM_BASE
%
%see also FM_SPF
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    04-Jan-2007
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

obj.Areas = base(obj.Areas,obj);
obj.Regions = base(obj.Regions,obj);
obj.Shunt = base(obj.Shunt,obj);
obj.SW = base(obj.SW,obj);
obj.PV = base(obj.PV,obj);
obj.PQ = base(obj.PQ,obj);
obj.Line = base(obj.Line,obj);
obj.Lines = base(obj.Lines,obj);
obj.Fault = base(obj.Fault,obj);
obj.Demand = base(obj.Demand,obj);
obj.Supply = base(obj.Supply,obj);
obj.Rmpg = base(obj.Rmpg,obj);
obj.Rmpl = base(obj.Rmpl,obj);
obj.Vltn = base(obj.Vltn,obj);
obj.Pl = base(obj.Pl,obj);
obj.Mn = base(obj.Mn,obj);
obj.Ltc = base(obj.Ltc,obj);
obj.Phs = base(obj.Phs,obj);
obj.Tap = base(obj.Tap,obj);
obj.Tg = base(obj.Tg,obj);
obj.Svc = base(obj.Svc,obj);
obj.Statcom = base(obj.Statcom,obj);
obj.Tcsc = base(obj.Tcsc,obj);
obj.Sssc = base(obj.Sssc,obj);
obj.Upfc = base(obj.Upfc,obj);
obj.Hvdc = base(obj.Hvdc,obj);
obj.Sofc = base(obj.Sofc,obj);
obj.SSR = base(obj.SSR,obj);
obj.Ind = base(obj.Ind,obj);
obj.Syn = base(obj.Syn,obj);
obj.COI = base(obj.COI,obj);
obj.Mass = base(obj.Mass,obj);
obj.Cswt = base(obj.Cswt,obj);
obj.Dfig = base(obj.Dfig,obj);
obj.Ddsg = base(obj.Ddsg,obj);
obj.WTFR = base(obj.WTFR,obj);
obj.Spv = base(obj.Spv,obj);
obj.Spq = base(obj.Spq,obj);
