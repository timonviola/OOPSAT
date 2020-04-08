function a = setx0(a,psat_obj)


if ~a.n, return, end

V1 = psat_obj.DAE.y(a.vbus);

for k = 1:a.n
  idx = findbus(psat_obj.PQ,a.bus(k));
  if isempty(idx)
    warn(a,k,'No psat_obj.PQ load found.',psat_obj)
    a.con(k,6) = 0;
    a.con(k,7) = 0;
    a.con(k,8) = 0;
    a.con(k,9) = 0;
    a.con(k,10) = 0;
    a.con(k,11) = 0;
  else
    P = a.u(k)*psat_obj.PQ.P0(idx)*sum(a.con(k,[6:8]))/100;
    Q = a.u(k)*psat_obj.PQ.Q0(idx)*sum(a.con(k,[9:11]))/100;
    psat_obj.PQ = pqsub(psat_obj.PQ,idx,P,Q);
    a.con(k,6) = a.con(k,6)*psat_obj.PQ.P0(idx)/100;
    a.con(k,7) = a.con(k,7)*psat_obj.PQ.P0(idx)/100;
    a.con(k,8) = a.con(k,8)*psat_obj.PQ.P0(idx)/100;
    a.con(k,9) = a.con(k,9)*psat_obj.PQ.Q0(idx)/100;
    a.con(k,10) = a.con(k,10)*psat_obj.PQ.Q0(idx)/100;
    a.con(k,11) = a.con(k,11)*psat_obj.PQ.Q0(idx)/100;
    psat_obj.PQ = remove(psat_obj.PQ,idx,'zero');
  end
end

%check time constants
idx = find(a.con(:,5) == 0);
if idx
  warn(a,idx,'Tf cannot be zero. Tf = 0.001 s will be used.',psat_obj)
  a.con(idx,5) = 0.001;
end

%variable initialization
psat_obj.DAE.x(a.x) = -a.u.*V1./a.con(:,5);
a.dat(:,1) = V1;

%check limits
psat_obj.fm_disp('Initialization of Jimma''s loads completed.')
