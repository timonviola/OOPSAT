function a = setx0(a,psat_obj)

if ~a.n, return, end

V1 = psat_obj.DAE.y(a.vbus);
t1 = psat_obj.DAE.y(a.bus);
 
for k = 1:a.n
  idx = findbus(psat_obj.PQ,a.bus(k));
  if isempty(idx)
    warn(a,idx,'No psat_obj.PQ load found for initialization.')
    a.con(k,6) = 0;
    a.con(k,10) = 0;
  else
    P = a.u(k)*psat_obj.PQ.P0(idx)*sum(a.con(k,6))/100;
    Q = a.u(k)*psat_obj.PQ.Q0(idx)*sum(a.con(k,10))/100;
    psat_obj.PQ = pqsub(psat_obj.PQ,idx,P,Q);
    a.con(k,6) = a.con(k,6)*psat_obj.PQ.P0(idx)/100;
    a.con(k,10) = a.con(k,10)*psat_obj.PQ.Q0(idx)/100;
    psat_obj.PQ = remove(psat_obj.PQ,idx,'zero');
  end
end

%check time constants
idx = find(a.con(:,13) == 0);
if idx
  warn(a,idx, 'Time constant Tfv cannot be zero. Tfv = 0.001 s will be used.'),
end
a.con(idx,13) = 0.001;
idx = find(a.con(:,14) == 0);
if idx
  warn(a,idx, 'Time constant Tft cannot be zero. Tft = 0.001 s will be used.'),
end
a.con(idx,14) = 0.001;

%variable initialization
psat_obj.DAE.x(a.x) = -a.u.*V1./a.con(:,13);
x = psat_obj.DAE.x(a.x);
psat_obj.DAE.x(a.y) = 0;
y = psat_obj.DAE.x(a.y);
a.dat(:,1) = V1;
a.dat(:,2) = t1;

%check limits
fm_disp('Initialization of mixed loads completed.')
