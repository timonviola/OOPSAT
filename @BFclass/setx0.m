function a = setx0(a,psat_obj)

if ~a.n, return, end

x = psat_obj.DAE.x(a.x);
w = psat_obj.DAE.x(a.w);
theta = psat_obj.DAE.y(a.bus);
Tf = a.con(:,2);
Tw = a.con(:,3);
theta0 = a.dat(:,1);
k = a.dat(:,2);

%check time constants
idx = find(Tf == 0);
if idx
  warn(a,idx, ['Time constant Tf cannot be zero. Tf = 0.001 ' ...
               's will be used.'])
end
a.con(idx,2) = 0.001;
idx = find(Tw == 0);
if idx
  warn(a,idx, ['Time constant Tw cannot be zero. Tw = 0.001 ' ...
               's will be used.'])
end
a.con(idx,3) = 0.001;

%variable initialization
psat_obj.DAE.x(a.x) = 0;
psat_obj.DAE.x(a.w) = a.u;
a.dat(:,1) = theta;
a.dat(:,2) = 1./Tf/(2*pi*psat_obj.Settings.freq);

fm_disp('Initialization of Bus Frequency Measurement completed.')

