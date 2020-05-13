%POWERFLOWRESULTS Extract power-flow data from PSAT object.
%
%   res = POWERFLOWRESULTS(OBJ) returns the following data
%   as fields of the output res struct:
%     o PG active power generation/load at all buses
%     o QG reactive power generation/load at all buses
%     o VM bus voltage magnitude
%     o Sf complex power branch flows (from)
%     o St complex power branch flows (to)
%     o gen
%       - PG generator active power [MW]
%       - QG generator reactive power [MVAR]
%
%   res = obj.POWERFLOWRESULTS('print') prints the BUS and
%   BRANCH FLOW data to STDOUT.
%
%   See also PSAT.GENLIST.
function results = powerFlowResults(obj,varargin)
PRINT = false;
switch obj.Settings.absvalues
 case 'on'
  MVA  = obj.Settings.mva;
  VB   = getkv(obj.Bus,0,0);
  MW   = '[MW]';
  MVar = '[MVar]';
  kV   = '[kV]';
 otherwise
  MVA  = 1;
  VB   = getones(obj.Bus);
  MW   = '[p.u.]';
  MVar = '[p.u.]';
  kV   = '[p.u.]';
end
raddeg = 'rad';
nseries = obj.Settings.nseries; % nBR - number of lines
iline = [1:nseries]'; % vBR - vector of branches
if nargin > 1
  mode = varargin{1};
  switch mode
    case 'print'
      PRINT = true;
    otherwise
      warning('OOPSAT:varargin:unknownOption', 'Unknown input option.')
  end
end

% ----- bus voltages: 
[busNames, ordbus] = sort(obj.Bus.names(1:end)); %#ok b cell array of names,
busNames = cell2mat(obj.Bus.names);

vBus = obj.DAE.y(ordbus+obj.Bus.n).*VB(ordbus);
% bus voltages
% ps.DAE.y(ps.Bus.v)

% ------ voltage angles
angs = obj.DAE.y(ordbus); % in radian (.*180/pi to convert deg) matpower uses deg
% ----- REAL, REACTIVE POWERS Pgs - P_flow
%              Qgs - Q_flow
%              Pls - P_loss
%              Qls - Q_loss
Pgs = obj.Bus.Pg(ordbus)*MVA;
Qgs = obj.Bus.Qg(ordbus)*MVA;
Pls = obj.Bus.Pl(ordbus)*MVA;
Qls = obj.Bus.Ql(ordbus)*MVA;
if PRINT
  fprintf('\n\n<strong>BUS</strong>\n')
  header = {'Bus','V','phase','P gen','Q gen','P load','Q load'; ...
                ' ', kV, ['[',raddeg,']'],MW,MVar,MW,MVar};
  [nRow, nCol] = size(header);
  for i = 1:nRow
      fprintf([repmat('%8s',1,nCol) '\n'],header{i,:})
  end
  for i = 1:length(ordbus)
      fprintf('%2s%5s%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\n',...
          ' ',busNames(i,1:end),vBus(i),angs(i),Pgs(i),Qgs(i),Pls(i),Qls(i))
  end
end
%% ------ branch flows
[P_s,Q_s,P_r,Q_r,fr_bus,to_bus] = fm_flows(obj,'bus');
Sf = sqrt(P_s(1:obj.Line.n).^2+Q_s(1:obj.Line.n).^2);
St = sqrt(P_r(1:obj.Line.n).^2+Q_r(1:obj.Line.n).^2);

% to get the right number of to-from lines:
line_ffr = [iline, fr_bus, to_bus, P_s*MVA, Q_s*MVA];
line_fto = [iline, to_bus, fr_bus, P_r*MVA, Q_r*MVA];

fRows = cell(length(line_ffr(:,2)),1);
tRows = fRows;
for iii = 1:length(line_fto(:,2))
    fRows{iii} = busNames(line_ffr(iii,2),:);
    tRows{iii} = busNames(line_ffr(iii,3),:);
end
fRows = cell2mat(fRows);
tRows = cell2mat(tRows);
% losses
% --------------------------------------------------------------------
line_p_losses = line_ffr(:,4) + line_fto(:,4);
line_q_losses = line_ffr(:,5) + line_fto(:,5);

% all_line_flow_data = [line_ffr(:,1),line_ffr(:,4),line_ffr(:,5), ...
%     line_p_losses,line_q_losses];
if PRINT
  fprintf('\n\n<strong>BRANCH FLOW</strong>\n')
  header = {'From Bus','To Bus','Line','P Flow','Q Flow','P Loss','Q Loss',...
      'S From', 'S To';' ',' ',' ',MW,MVar,MW,MVar,MVar,MVar};
  [nRow, nCol] = size(header);
  for i = 1:nRow
      fprintf([repmat('%8s',1,nCol) '\n'],header{i,:})
  end
  for i = 1:length(line_q_losses)
      fprintf('%5s%10s%8d%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\n',...
          fRows(i,1:end),tRows(i,1:end),line_ffr(i,1),line_ffr(i,4),...
          line_ffr(i,5),line_p_losses(i),line_q_losses(i),Sf(i),St(i))
  end
end
results.PG = Pgs;
results.QG = Qgs;
results.VM = vBus;
results.Sf = Sf;
results.St = St;
results.gen.PG = Pgs(obj.genlist).*obj.Settings.mva;
results.gen.QG = Qgs(obj.genlist).*obj.Settings.mva;
end










% % PSAT FM_REPORT : some useful variables
% % --------------------------------------------------------------------
% 
% Vs = DAE.y(ordbus+Bus.n).*VB(ordbus);
% angs = DAE.y(ordbus);
% raddeg = 'rad';
% if ishandle(Fig.stat)
%   hdlT = findobj(Fig.stat,'Tag','PushAngle');
%   string = get(hdlT,'UserData');
%   if ~strcmp(string,'rad')
%     angs = angs*180/pi;
%     raddeg = 'deg';
%   end
% end
% 
% Pgs = Bus.Pg(ordbus)*MVA;
% Qgs = Bus.Qg(ordbus)*MVA;
% Pls = Bus.Pl(ordbus)*MVA;
% Qls = Bus.Ql(ordbus)*MVA;
