function a = setx0(a,psat_obj)

if ~a.n, return, end

check = 1;

bt_Pref = a.con(:,2)./psat_obj.Settings.mva;
% bt_Qref = a.con(:,3)./psat_obj.Settings.mva;

V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);

Vd = -V.*st;
Vq =  V.*ct;


% % Vref
a.dat(:,1) = V;

% % Initialization of state variables

for i = 1:a.n
 
  % find & delete static generators
  if ~fm_rmgen(a.u(i)*a.bus(i)), check = 0; end
end

% state variables initialization

% id = bt_Pref;
% iq = zeros(a.n,1);
% psat_obj.DAE.x(a.btx1) = zeros(a.n,1);
% psat_obj.DAE.x(a.id) = a.u.*id;
% psat_obj.DAE.x(a.iq) = a.u.*iq;

idiq = [Vd Vq; Vq -Vd]\[psat_obj.Bus.Pg(a.bus);psat_obj.Bus.Qg(a.bus)];
id = idiq(1);
iq = idiq(2);

psat_obj.DAE.x(a.btx1) = a.u.*psat_obj.Bus.Qg(a.bus);
psat_obj.DAE.x(a.id) = a.u.*id;
psat_obj.DAE.x(a.iq) = a.u.*iq;
psat_obj.DAE.y(a.vref) = a.u.*a.dat(:,1);

if ~check
  fm_disp('Solar photo-voltaic generators (PV model) cannot be properly initialized.')
else
  fm_disp('Initialization of Solar Photo-Voltaic Generators (PV model) completed.')
end

