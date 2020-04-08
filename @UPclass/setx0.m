function a = setx0(a,psat_obj)

if ~a.n, return, end

% reset transmission line reactance and admittance matrix
psat_obj.Line = addxl(psat_obj.Line,a.line,a.u.*a.xcs);
if sum(a.u), psat_obj.Line = build_y(psat_obj.Line); end

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
a1 = psat_obj.DAE.y(a.bus1);
a2 = psat_obj.DAE.y(a.bus2);

vp_max = a.con(:,9);
vp_min = a.con(:,10);
vq_max = a.con(:,11);
vq_min = a.con(:,12);
iq_max = a.con(:,13);
iq_min = a.con(:,14);

kp = a.Cp./(1-a.Cp);
V = V1.*exp(psat_obj.jay.*a1)-V2.*exp(psat_obj.jay.*a2);
theta = angle(V)-pi/2;

% if vp = 0, gamma is as follows:
a.gamma = pi/2+theta-a1;

psat_obj.DAE.x(a.vp) = 0;
psat_obj.DAE.x(a.vq) = a.u.*kp.*V1.*sin(a1-a2)./sin(a1-a2+a.gamma);
psat_obj.DAE.x(a.iq) = a.u.*psat_obj.Bus.Qg(a.bus1)./V1;

idx = find(psat_obj.DAE.x(a.vp) > vp_max);
if idx, warn(a,idx,' Vp is over its max limit.'), end
idx = find(psat_obj.DAE.x(a.vp) < vp_min);
if idx, warn(a,idx,' Vp is under its min limit.'), end

idx = find(psat_obj.DAE.x(a.vq) > vq_max);
if idx, warn(a,idx,' Vq is over its max limit.'), end
idx = find(psat_obj.DAE.x(a.vq) < vq_min);
if idx, warn(a,idx,' Vq is under its min limit.'), end

idx = find(psat_obj.DAE.x(a.iq) > iq_max);
if idx, warn(a,idx,' Ish is over its max limit.'), end
idx = find(psat_obj.DAE.x(a.iq) < iq_min);
if idx, warn(a,idx,' Ish is under its min limit.'), end

psat_obj.DAE.x(a.vp) = max(psat_obj.DAE.x(a.vp),vp_min);
psat_obj.DAE.x(a.vp) = min(psat_obj.DAE.x(a.vp),vp_max);

psat_obj.DAE.x(a.vq) = max(psat_obj.DAE.x(a.vq),vq_min);
psat_obj.DAE.x(a.vq) = min(psat_obj.DAE.x(a.vq),vq_max);

psat_obj.DAE.x(a.iq) = max(psat_obj.DAE.x(a.iq),iq_min);
psat_obj.DAE.x(a.iq) = min(psat_obj.DAE.x(a.iq),iq_max);

% reference voltages
a.Vp0 = psat_obj.DAE.x(a.vp);
a.Vq0 = psat_obj.DAE.x(a.vq);
a.Vref = psat_obj.DAE.x(a.iq)./a.con(:,7) + V1;   
psat_obj.DAE.y(a.vp0) = a.Vp0;
psat_obj.DAE.y(a.vq0) = a.Vq0;
psat_obj.DAE.y(a.vref) = a.Vref;

% checking for synchronous machines and psat_obj.PV generators
for i = 1:a.n
  idxg = findbus(psat_obj.Syn,a.bus1(i));
  if ~isempty(idxg)
    warn(a,i,[' UPFC cannot be connected at the same bus as ' ...
                'synchronous machines.'])
    continue
  end
  if a.u(i)
    idx = findbus(psat_obj.PV,a.bus1(i));
    psat_obj.PV = remove(psat_obj.PV,idx);
    if isempty(idx)
      warn(a,i,' no psat_obj.PV generator found at the bus.')
    end
  end
end

fm_disp('Initialization of UPFCs completed.')  
