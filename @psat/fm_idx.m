function  fm_idx(obj,flag)
% FM_IDX define formatted and unformatted names of system variables
%
% FM_IDX(FLAG)
%   FLAG  1  -> power flow and state variables
%         2  -> determinants and eigenvalues
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    05-Mar-2004
%Update:    14-Sep-2005
%Update:    19-Dec-2005
%Version:   1.2.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

nL = obj.Settings.nseries;

switch flag

 case 1  % power flow and state variables

  nidx = obj.DAE.n+obj.DAE.m+2*obj.Bus.n+4*nL;

  % cell array of unformatted variable names
  obj.Varname.uvars = cell(nidx,1);

  % cell array of formatted (LaTeX style) variable names
  obj.Varname.fvars = cell(nidx,1);

  % state variables
  if obj.DAE.n
    for j = 1:length(obj.Varname.fnamex)
%       eval(['global ',obj.Varname.compx{j}]); - how to declear 115 global
%       vars in 3 lines - lol.
      nome = eval(['obj.', obj.Varname.compx{j},'.',obj.Varname.unamex{j}]);
      if ~isempty(nome)
        b = find(nome);
        numero = length(b);
        for i = 1:numero
          obj.Varname.uvars{nome(b(i))} = [obj.Varname.unamex{j},'_', ...
                              obj.Varname.compx{j},'_',  int2str(b(i))];
          obj.Varname.fvars{nome(b(i))} = [obj.Varname.fnamex{j},'_{', ...
                              obj.Varname.compx{j},' ', int2str(b(i)),'}']; % wow some latex syntax
        end
      end
    end
  end

  % algebraic variables
  idx1 = obj.DAE.n+obj.Bus.n;
  idx2 = obj.DAE.n+obj.DAE.m;
  idx3 = idx2+obj.Bus.n;
  for j = 1:obj.Bus.n
    b = strrep(obj.Bus.names{j,1},'_',' ');
    % theta
    obj.Varname.fvars{obj.DAE.n+j} = [char(92),'theta_{', b,'}'];
    obj.Varname.uvars{obj.DAE.n+j} = ['theta_', b];
    % V
    obj.Varname.fvars{idx1+j} = ['V_{', b,'}'];
    obj.Varname.uvars{idx1+j} = ['V_', b];
    % P
    obj.Varname.fvars{idx2+j} = ['P_{', b,'}'];
    obj.Varname.uvars{idx2+j} = ['P_', b];
    % Q
    obj.Varname.fvars{idx3+j} = ['Q_{', b,'}'];
    obj.Varname.uvars{idx3+j} = ['Q_', b];
  end

  if obj.DAE.m > 2*obj.Bus.n
    for j = 1:length(obj.Varname.fnamey)
%       eval(['global ',obj.Varname.compy{j}]);
      nome = eval(['obj.',obj.Varname.compy{j},'.',obj.Varname.unamey{j}]);
      if ~isempty(nome)
        b = find(nome);
        numero = length(b);
        for i = 1:numero
          obj.Varname.uvars{obj.DAE.n+nome(b(i))} = [obj.Varname.unamey{j},'_', ...
                              obj.Varname.compy{j},'_',  int2str(b(i))];
          obj.Varname.fvars{obj.DAE.n+nome(b(i))} = [obj.Varname.fnamey{j},'_{', ...
                              obj.Varname.compy{j},' ', int2str(b(i)),'}'];
        end
      end
    end
  end

  fr = [obj.Line.fr; obj.Ltc.bus1; obj.Phs.bus1; obj.Hvdc.bus1; obj.Lines.bus1];
  to = [obj.Line.to; obj.Ltc.bus2; obj.Phs.bus2; obj.Hvdc.bus2; obj.Lines.bus2];

  idx1 = obj.DAE.n+obj.DAE.m+2*obj.Bus.n;
  idx2 = idx1 + nL;
  idx3 = idx2 + nL;
  idx4 = idx3 + nL;
  idx5 = idx4 + nL;
  idx6 = idx5 + nL;
  idx7 = idx6 + nL;
  idx8 = idx7 + nL;

  for j = 1:nL
    b = obj.Bus.names{fr(j),1};
    d = obj.Bus.names{to(j),1};
    % P_ij
    obj.Varname.fvars{idx1+j} = ['P_{',b,' ',d,'}'];
    obj.Varname.uvars{idx1+j} = ['P_',b,'_',d];
    % P_ji
    obj.Varname.fvars{idx2+j} = ['P_{',d,' ',b,'}'];
    obj.Varname.uvars{idx2+j} = ['P_',d,'_',b];
    % Q_ij
    obj.Varname.fvars{idx3+j} = ['Q_{',b,' ',d,'}'];
    obj.Varname.uvars{idx3+j} = ['Q_',b,'_',d];
    % Q_ji
    obj.Varname.fvars{idx4+j} = ['Q_{',d,' ',b,'}'];
    obj.Varname.uvars{idx4+j} = ['Q_',d,'_',b];
    % I_ij
    obj.Varname.fvars{idx5+j} = ['I_{',b,' ',d,'}'];
    obj.Varname.uvars{idx5+j} = ['I_',b,'_',d];
    % I_ji
    obj.Varname.fvars{idx6+j} = ['I_{',d,' ',b,'}'];
    obj.Varname.uvars{idx6+j} = ['I_',d,'_',b];
    % S_ij
    obj.Varname.fvars{idx7+j} = ['S_{',b,' ',d,'}'];
    obj.Varname.uvars{idx7+j} = ['S_',b,'_',d];
    % S_ji
    obj.Varname.fvars{idx8+j} = ['S_{',d,' ',b,'}'];
    obj.Varname.uvars{idx8+j} = ['S_',d,'_',b];
  end

  obj.Varname.nvars = length(obj.Varname.uvars);
  % plot variables
  if isempty(obj.Varname.idx)
    % use default variables
    obj.Varname.fixed = 1;
    obj.Varname.custom = 0;
    obj.Varname.x = 1;
    obj.Varname.y = 1;
    obj.Varname.P = 0;
    obj.Varname.Q = 0;
    obj.Varname.Pij = 0;
    obj.Varname.Qij = 0;
    obj.Varname.Iij = 0;
    obj.Varname.Sij = 0;
    obj.Varname.idx = [1:(obj.DAE.n+obj.DAE.m)]';
  else
    % check for possible index inconsistency
    idx = find(obj.Varname.idx > obj.Varname.nvars);
    if ~isempty(idx)
      obj.Varname.idx(idx) = [];
    end
  end

 case 2 % determinants and eigenvalues

  idx0 = obj.DAE.n+obj.DAE.m+2*obj.Bus.n+8*nL;
  obj.Varname.fvars{idx0+1} = 'det(A_S)';
  %obj.Varname.fvars{idx0+2} = 'det(J_l_f)';
  %obj.Varname.fvars{idx0+3} = 'det(J_l_f_d)';
  obj.Varname.uvars{idx0+1} = 'det(As)';
  %obj.Varname.uvars{idx0+2} = 'det(Jlf)';
  %obj.Varname.uvars{idx0+3} = 'det(Jlfd)';

  %idx0 = idx0+3;
  idx0 = idx0+1;
  for i = 1:obj.DAE.n
    obj.Varname.fvars{idx0+i} = [char(92),'lambda', '_{As (', int2str(i),')}'];
    obj.Varname.uvars{idx0+i} = ['eigenvalue_As', int2str(i)];
  end

%   idx0 = idx0+obj.DAE.n;
%   for i = 1:obj.Bus.n
%     obj.Varname.fvars{idx0+i} = [char(92),'lambda','_{Jlfr (', int2str(i),')}'];
%     obj.Varname.uvars{idx0+i} = ['eigenvalue_Jlfr', int2str(i)];
%   end

%   idx0 = idx0+obj.Bus.n;
%   for i = 1:obj.Bus.n
%     obj.Varname.fvars{idx0+i} = [char(92),'lambda','_{Jlfdr (', int2str(i),')}'];
%     obj.Varname.uvars{idx0+i} = ['eigenvalue_Jlfdr', int2str(i)];
%   end

  obj.Varname.nvars = length(obj.Varname.uvars);

end
