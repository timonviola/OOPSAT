function p = gcall(p, psat_obj)

if ~p.n, return, end

idx = find(p.u);
psat_obj.DAE.g(p.bus(idx)) = 0;
if ~psat_obj.Settings.pv2pq 
  psat_obj.DAE.g(p.vbus(idx)) = 0;   
  return
end

% ================================================
% check reactive power limits
% ================================================

% find max mismatch error
if isempty(psat_obj.DAE.g) || psat_obj.Settings.iter < psat_obj.Settings.pv2pqniter
  prev_err = 1e6;
else
  prev_err = 2*psat_obj.Settings.error;
end

% Q min
% ================================================

% Limit check improved by Lars L. 2006-01.
[tmp,idx] = max(p.u.*(p.con(:,7) - psat_obj.DAE.g(p.vbus) - prev_err));  

if tmp > 0 && ~psat_obj.PV.newpq
  if ~p.dq(idx)
    psat_obj.fm_disp(['Switch SW bus <', ...
             psat_obj.Bus.names{p.bus(idx)}, ...
             '> to theta-Q bus: Min Qg reached'])
  end
  p.qg(idx) = p.con(idx,7);    
  p.dq(idx) = 1;
end

% Q max
% ================================================

% Limit check improved by Lars L. 2006-01.
[tmp,idx] = min(p.u.*(p.con(:,6) - psat_obj.DAE.g(p.vbus) + prev_err));

if tmp < 0 && ~psat_obj.PV.newpq 
  if ~p.dq(idx)
    psat_obj.fm_disp(['Switch SW bus <', ...
             psat_obj.Bus.names{p.bus(idx)}, ...
             '> to theta-Q bus: Max Qg reached'])
  end
  p.qg(idx) = p.con(idx,6);    
  p.dq(idx) = 1;
end

% Generator reactive powers
% ================================================

psat_obj.DAE.g(p.vbus) = psat_obj.DAE.g(p.vbus) - p.u.*p.qg;
psat_obj.DAE.g(p.vbus(find(~p.dq & p.u))) = 0;
