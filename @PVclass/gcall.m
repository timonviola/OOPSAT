function p = gcall(p,psat_obj)
if ~p.n, return, end

K = p.u.*(1+psat_obj.DAE.kg*p.con(:,10));
psat_obj.DAE.g(p.bus) = psat_obj.DAE.g(p.bus) - K.*p.con(:,4);
if ~psat_obj.Settings.pv2pq
  psat_obj.DAE.g(p.vbus(find(p.u))) = 0;   
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
p.newpq = 0;

% Q min
% ================================================

% Limit check improved by Lars L. 2006-01.
[tmp,idx] = max(p.u.*(p.con(:,7) - psat_obj.DAE.g(p.vbus) - prev_err));  

if tmp > 0
  if ~p.pq(idx)
    psat_obj.fm_disp(['Switch PV bus <', psat_obj.Bus.names{p.bus(idx)}, '> to PQ bus: Min Qg reached'])
  end
  p.qg(idx) = p.con(idx,7);    
  p.pq(idx) = 1;
  p.newpq = ~psat_obj.Settings.multipvswitch;
end

% Q max
% ================================================

% Limit check improved by Lars L. 2006-01.
[tmp,idx] = min(p.u.*(p.con(:,6) - psat_obj.DAE.g(p.vbus) + prev_err));

if tmp < 0 && ~p.newpq
  if ~p.pq(idx)
    psat_obj.fm_disp(['Switch PV bus <', psat_obj.Bus.names{p.bus(idx)}, '> to PQ bus: Max Qg reached'])
  end
  p.qg(idx) = p.con(idx,6);    
  p.pq(idx) = 1;
  p.newpq = ~psat_obj.Settings.multipvswitch;
end

% Generator reactive powers
% ================================================

psat_obj.DAE.g(p.vbus) = psat_obj.DAE.g(p.vbus) - p.u.*p.qg;
psat_obj.DAE.g(p.vbus(find(~p.pq & p.u))) = 0;
