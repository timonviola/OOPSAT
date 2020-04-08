function a = setx0(a,psat_obj)

if ~a.n, return, end

ty3 = a.con(:,2) == 3;
typwr = a.con(:,10) == 1;
tyang = a.con(:,10) == 2;

kp = a.Cp./(1-a.Cp);

psat_obj.DAE.x(a.vcs) = a.u.*kp.*ssscden(a);
idx3 = find(ty3);
if ~isempty(idx3)
  psat_obj.DAE.x(a.vpi(idx3)) = a.u(idx3).*psat_obj.DAE.x(a.vcs(idx3));
end

% reset transmission line reactance and admittance matrix
psat_obj.Line = addxl(psat_obj.Line,a.line,a.u.*a.xcs);
if sum(a.u), psat_obj.Line = build_y(psat_obj.Line); end

[Ps,Qs,Pr,Qr] = flows(psat_obj.Line,psat_obj,'pq',a.line);
[Ps,Qs,Pr,Qr] = flows(a,psat_obj,Ps,Qs,Pr,Qr,'sssc');

a.Pref = Ps + ty3.*tyang.*Pr;

vcs_max = a.u.*a.con(:,8);
vcs_min = a.u.*a.con(:,9);

idx = find(psat_obj.DAE.x(a.vcs) > vcs_max);
if idx, warn(a,idx,' Vs is over its max limit.'), end
idx = find(psat_obj.DAE.x(a.vcs) < vcs_min);
if idx, warn(a,idx,' Vs is under its min limit.'), end
psat_obj.DAE.x(a.vcs) = max(psat_obj.DAE.x(a.vcs),vcs_min);
psat_obj.DAE.x(a.vcs) = min(psat_obj.DAE.x(a.vcs),vcs_max);

% reference voltage signal
a.V0 = psat_obj.DAE.x(a.vcs);

psat_obj.DAE.y(a.v0) = a.V0;
psat_obj.DAE.y(a.pref) = a.Pref;

fm_disp('Initialization of SSSC completed.')
