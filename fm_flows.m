function varargout = fm_flows(psat_obj,varargin)
%FM_FLOWS computes active and reactive flows in transmission lines
%
% [PIJ,QIJ,PJI,QJI] = FM_FLOWS
% [PIJ,QIJ,PJI,QJI,FRV,TOV] = FM_FLOWS
% [PIJ,QIJ,PJI,QJI,FR,TO] = FM_FLOWS('ONLYIDX')
% [FR,TO] = FM_FLOWS('BUS')
% [BUSES,NISLAND] = FM_FLOWS('CONNECTIVITY')
% [BUSES,NISLAND] = FM_FLOWS('CONNECTIVITY','VERBOSE')
%
%see also classes LINE, UPFC, TCSC and SSSC
%
%Author:    Federico Milano
%Date:      03-Aug-2006
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

if (nargin-1)
  type = varargin{1};
else
  type = 'voltage';
end

if ~strcmp(type,'onlyidx')
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Line,psat_obj);
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Tcsc,psat_obj,Ps,Qs,Pr,Qr);
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Sssc,psat_obj,Ps,Qs,Pr,Qr);
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Upfc,psat_obj,Ps,Qs,Pr,Qr);
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Ltc,psat_obj,Ps,Qs,Pr,Qr);
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Phs,psat_obj,Ps,Qs,Pr,Qr);
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Hvdc,psat_obj,Ps,Qs,Pr,Qr);
  [Ps,Qs,Pr,Qr] = flows(psat_obj.Lines,psat_obj,Ps,Qs,Pr,Qr);
end

switch type
 case {'bus','onlyidx','connectivity'}
  Fr = [psat_obj.Line.fr; psat_obj.Ltc.bus1; psat_obj.Phs.bus1; psat_obj.Hvdc.bus1; psat_obj.Lines.bus1];
  To = [psat_obj.Line.to; psat_obj.Ltc.bus2; psat_obj.Phs.bus2; psat_obj.Hvdc.bus2; psat_obj.Lines.bus2];
 otherwise
  Fr = [psat_obj.Line.vfr; psat_obj.Ltc.v1; psat_obj.Phs.v1; psat_obj.Hvdc.v1; psat_obj.Lines.v1];
  To = [psat_obj.Line.vto; psat_obj.Ltc.v2; psat_obj.Phs.v2; psat_obj.Hvdc.v2; psat_obj.Lines.v2];
end

switch nargout
 case 2
  varargout{1} = Fr;
  varargout{2} = To;
 case 4
  varargout{1} = Ps;
  varargout{2} = Qs;
  varargout{3} = Pr;
  varargout{4} = Qr;
 case 6
  varargout{1} = Ps;
  varargout{2} = Qs;
  varargout{3} = Pr;
  varargout{4} = Qr;
  varargout{5} = Fr;
  varargout{6} = To;
end

if strcmp(type,'connectivity')

  if psat_obj.Bus.n > 1000,
    msg = ['* Warning: The connectivity check is disabled for ' ...
            'networks with more than 1000 buses.'];
    fm_disp(msg)
    return
  end

  if nargin == 2
    flag = varargin{2};
  else
    flag = 'mute';
  end

  nb = psat_obj.Bus.n;
  U = [psat_obj.Line.u; psat_obj.Ltc.u; psat_obj.Phs.u; psat_obj.Hvdc.u; psat_obj.Lines.u];

  % connectivity matrix
  connect_mat = ...
      sparse(Fr,Fr,1,nb,nb) + ...
      sparse(Fr,To,U,nb,nb) + ...
      sparse(To,To,1,nb,nb) + ...
      sparse(To,Fr,U,nb,nb);

  % find network islands using QR factorization
  if psat_obj.Settings.octave
    [Q,R] = qr(full(connect_mat));
  else
    [Q,R] = qr(connect_mat);
  end
  idx = find(abs(sum(R,2)-diag(R)) < 1e-5);

  % find generators per island
  nisland = length(idx);
  buses = [];
  if nisland > 1
    buses = cell(nisland,1);
    disp(['There are ',num2str(nisland),' islanded networks'])
    gen_bus = [getbus(psat_obj.Syn);getbus(psat_obj.SW);getbus(psat_obj.PV);getbus(psat_obj.PQ,'gen')];
    for i = 1:nisland
      buses{i} = find(Q(:,idx(i)));
      nbuses = length(buses{i});
      ngen = length(intersect(gen_bus,buses{i}));
      if strcmp(flag,'verbose')
        fm_disp([' * * Sub-network ', num2str(i),' has ', ...
                 num2str(nbuses),' bus(es) and ', ...
                 num2str(ngen),' generator(s)'])
      end
    end
  end

  if nargout
    varargout{1} = buses;
    varargout{2} = nisland;
  end

end
