function a = setx0(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.x(a.vm) = a.u.*psat_obj.DAE.y(a.vbus);
psat_obj.DAE.x(a.thetam) = a.u.*psat_obj.DAE.y(a.bus);

idx = find(a.con(:,4) == 0);
if ~isempty(idx)
  warn(a,idx, [' Time constant Tv cannot be 0. Tv = 0.05 will be ' ...
               'used.'])
  a.con(idx,4) = 0.05;
end

idx = find(a.con(:,5) == 0);
if ~isempty(idx)
  warn(a,idx, ' Time constant Ta cannot be 0. Ta = 0.05 will be used.')
  a.con(idx,5) = 0.05;
end

a.dat = [1./a.con(:,4), 1./a.con(:,5)];

psat_obj.fm_disp('Initialization of PMUs completed.')


