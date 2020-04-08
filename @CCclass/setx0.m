function a = setx0(a,psat_obj)

if ~a.n, return, end

% variable initialization
psat_obj.DAE.x(a.q1) = 1;
psat_obj.DAE.y(a.q) = 1;

% pilot bus voltage reference
a.con(:,5) = psat_obj.DAE.y(a.vbus);

psat_obj.fm_disp('Initialization of Central Area Controllers completed.')

