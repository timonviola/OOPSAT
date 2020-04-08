function a = setx0(a,psat_obj)

if ~a.n, return, end

xd = a.con(:,4);
xq = a.con(:,5);

idx = find(a.con(:,3));

if ~isempty(idx)
  xd(idx) = psat_obj.Syn.con(a.syn(idx),8);
  xq(idx) = psat_obj.Syn.con(a.syn(idx),13);
  a.con(idx,4) = xd(idx);
  a.con(idx,5) = xq(idx);
end

% initialization
psat_obj.DAE.x(a.v) = zeros(a.n,1);
psat_obj.DAE.y(a.If) = ifield(a,1);

idx = find(psat_obj.DAE.y(a.If) > a.con(:,6));
if ~isempty(idx)
  warn(a,idx,' Field current is over its thermal limit. Reset to 1.2 I_f',psat_obj)
  a.con(idx,6) = 1.2*psat_obj.DAE.y(a.If(idx));
end

idx = find(a.con(:,2) <= 0);
if ~isempty(idx)
  warn(a,idx,' Integrator time constant is <= 0.  Reset to 10 s.',psat_obj)
  a.con(idx,2) = 10;
end

psat_obj.fm_disp('Initialization of Over Excitation Limiters completed.')
