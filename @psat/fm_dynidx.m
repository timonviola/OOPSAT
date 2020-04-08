function fm_dynidx(obj)
% FM_DYNIDX define indices of state variables for components
%           which are not initialized during the power flow
%           analysis
%
% FM_DYNIDX
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    17-Jul-2007
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

obj.Syn = dynidx(obj.Syn,obj);
obj.Exc = dynidx(obj.Exc,obj);
obj.Tg = dynidx(obj.Tg,obj);
obj.Oxl = dynidx(obj.Oxl,obj);
obj.Pss = dynidx(obj.Pss,obj);
obj.Fl = dynidx(obj.Fl,obj);
obj.Thload = dynidx(obj.Thload,obj);
obj.Svc = dynidx(obj.Svc,obj);
obj.Statcom = dynidx(obj.Statcom,obj);
obj.Tcsc = dynidx(obj.Tcsc,obj);
obj.Sssc = dynidx(obj.Sssc,obj);
obj.Upfc = dynidx(obj.Upfc,obj);
obj.Mass = dynidx(obj.Mass,obj);
obj.SSR = dynidx(obj.SSR,obj);
obj.Sofc = dynidx(obj.Sofc,obj);
obj.Cac = dynidx(obj.Cac,obj);
obj.Cluster = dynidx(obj.Cluster,obj);
obj.Exload = dynidx(obj.Exload,obj);
obj.Wind = dynidx(obj.Wind,obj);
obj.Cswt = dynidx(obj.Cswt,obj);
obj.Dfig = dynidx(obj.Dfig,obj);
obj.Ddsg = dynidx(obj.Ddsg,obj);
obj.Busfreq = dynidx(obj.Busfreq,obj);
obj.Pmu = dynidx(obj.Pmu,obj);
obj.Pod = dynidx(obj.Pod,obj);
obj.COI = dynidx(obj.COI,obj);
obj.Jimma = dynidx(obj.Jimma,obj);
obj.Mixload = dynidx(obj.Mixload,obj);
obj.WTFR = dynidx(obj.WTFR,obj);
obj.Spv = dynidx(obj.Spv,obj);
obj.Spq = dynidx(obj.Spq,obj);
