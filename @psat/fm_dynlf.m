function fm_dynlf(obj)
% FM_DYNLF define state variable indices for components which are
%          included in power flow analysis
%
% FM_DYNLF
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    17-Jul-2007
%Update:    22-Nov-2007
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

obj.DAE.n = 0;

obj.Ind = dynidx(obj.Ind,obj);
obj.Ltc = dynidx(obj.Ltc,obj);
obj.Tap = dynidx(obj.Tap,obj);
obj.Hvdc = dynidx(obj.Hvdc,obj);
obj.Phs = dynidx(obj.Phs,obj);
