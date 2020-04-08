function Fxcall(a,psat_obj)

if ~a.n, return, end


bt_Pref = a.con(:,2)./psat_obj.Settings.mva;
bt_Qref = a.con(:,3)./psat_obj.Settings.mva;

Tp = a.con(:,4);
Tq = a.con(:,5);


V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);

vd = -V.*st;
vq =  V.*ct;



% d f / d y
% -----------


idv = - (bt_Qref.*ct - bt_Pref.*st)./V ./V ./Tp;
idtet = -(bt_Qref.*st + bt_Pref.*ct)./V ./Tp;
iqv = - (bt_Pref.*ct + bt_Qref.*st)./V ./V ./Tq;
iqtet = (bt_Qref.*ct - bt_Pref.*st)./V ./Tq;

psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.id,a.vbus, a.u.*idv,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.id,a.bus, a.u.*idtet,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.iq,a.vbus,a.u.*iqv,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.iq,a.bus, a.u.*iqtet,psat_obj.DAE.n,psat_obj.DAE.m);

% d g / d x
% -----------

dPid = vd;
dPiq = vq;
dQid = vq;
dQiq = -vd;

psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.id,a.u.*dPid,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.bus,a.iq,a.u.*dPiq,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.id,a.u.*dQid,psat_obj.DAE.m,psat_obj.DAE.n);
psat_obj.DAE.Gx = psat_obj.DAE.Gx - sparse(a.vbus,a.iq,a.u.*dQiq,psat_obj.DAE.m,psat_obj.DAE.n);


% d f / d x
% -----------

psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.id,a.id,a.u.*1./Tp,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.iq,a.iq,a.u.*1./Tq,psat_obj.DAE.n,psat_obj.DAE.n);
