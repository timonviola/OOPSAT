function Fxcall(a,psat_obj)

if ~a.n, return, end


btx1 = psat_obj.DAE.x(a.btx1);

bt_Pref = a.con(:,2)./psat_obj.Settings.mva;
bt_vref = psat_obj.DAE.y(a.vref);

Tp = a.con(:,4);
Tq = a.con(:,5);

bt_kv = a.con(:,6);
bt_ki = a.con(:,7);

V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);



vd = -V.*st;
vq =  V.*ct;



% d f / d y
% -----------

btxdv = -bt_ki;

idv = - (ct.* (btx1 + bt_kv.*bt_vref) - bt_Pref.*st)./V ./V ./Tp;
idtet = -(st.*(btx1 + bt_kv.*(bt_vref - V)) + bt_Pref.*ct)./V ./Tp;
iqv = - (bt_Pref.*ct + st.*(bt_kv.*bt_vref))./V ./V ./Tq;
iqtet = (ct.*(btx1 + bt_kv.*(bt_vref - V)) - bt_Pref.*st)./V ./Tq;

psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.btx1,a.vbus, a.u.*btxdv,psat_obj.DAE.n,psat_obj.DAE.m);
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
didbtx = ct ./ (V.*Tp);
diqbtx = st ./ (V.*Tq);

psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.id,a.btx1,a.u.*didbtx,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx + sparse(a.iq,a.btx1,a.u.*diqbtx,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.id,a.id,a.u.*1./Tp,psat_obj.DAE.n,psat_obj.DAE.n);
psat_obj.DAE.Fx = psat_obj.DAE.Fx - sparse(a.iq,a.iq,a.u.*1./Tq,psat_obj.DAE.n,psat_obj.DAE.n);


% 
% % voltage control equation
% % ------------------------

btqm = psat_obj.PV.store;
btx1_max = btqm(1,6);
btx1_min = btqm(1,7);
z = btx1 > btx1_min & btx1 < btx1_max & a.u;

btxdvref = bt_ki;
idvref = (ct.* bt_kv) ./V ./Tp;
iqvref = (st.* bt_kv) ./V ./Tq;

psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.btx1,a.vref, z.*btxdvref,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.id,a.vref, a.u.*idvref,psat_obj.DAE.n,psat_obj.DAE.m);
psat_obj.DAE.Fy = psat_obj.DAE.Fy + sparse(a.iq,a.vref,a.u.*iqvref,psat_obj.DAE.n,psat_obj.DAE.m);

