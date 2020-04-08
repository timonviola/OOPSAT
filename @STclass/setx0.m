function a = setx0(a,psat_obj)

if ~a.n, return, end

V = psat_obj.DAE.y(a.vbus);
Kr = a.con(:,5);
Tr = a.con(:,6);
ist_max = a.u.*a.con(:,7);
ist_min = a.u.*a.con(:,8);

% eliminate psat_obj.PV components used for initializing STATCOM's
for i = 1:a.n
  idxg = findbus(psat_obj.Syn,a.bus(i));
  if ~isempty(idxg)
    warn(a,i,[' STATCOM cannot be connected at the same bus as ' ...
                     'synchronous machines.'])
    continue
  end
  if a.u(i)
    idx = findbus(psat_obj.PV,a.bus(i));
    psat_obj.PV = remove(psat_obj.PV,idx);
    if isempty(idx)
      warn(a,i,' no psat_obj.PV generator found at the bus.')
    end
  end
end
psat_obj.DAE.x(a.ist) = a.u.*psat_obj.Bus.Qg(a.bus)./V;
idx = find(psat_obj.DAE.x(a.ist) > ist_max);
if idx, warn(a,idx,' Ish is over its max limit.'), end
idx = find(psat_obj.DAE.x(a.ist) < ist_min);
if idx, warn(a,idx,' Ish is under its min limit.'), end
psat_obj.DAE.x(a.ist) = max(psat_obj.DAE.x(a.ist),ist_min);
psat_obj.DAE.x(a.ist) = min(psat_obj.DAE.x(a.ist),ist_max);

% reference voltages
a.Vref = psat_obj.DAE.x(a.ist)./Kr + V;
psat_obj.DAE.y(a.vref) = a.Vref;

psat_obj.fm_disp('Initialization of STATCOMs completed.')
