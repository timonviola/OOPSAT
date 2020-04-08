function fcall(a,psat_obj)
if ~a.n, return, end

btx1 = psat_obj.DAE.x(a.btx1);
id = psat_obj.DAE.x(a.id);
iq = psat_obj.DAE.x(a.iq);

V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);

bt_Pref = a.con(:,2)./psat_obj.Settings.mva;
% bt_vref = a.con(:,3);

Tp = a.con(:,4);
Tq = a.con(:,5);

bt_kv = a.con(:,6);
bt_ki = a.con(:,7);




bt_Qref = btx1 + ( bt_kv .* (psat_obj.DAE.y(a.vref) - V) );

psat_obj.DAE.f(a.btx1) = a.u.* ( bt_ki .* (psat_obj.DAE.y(a.vref) - V) );

psat_obj.DAE.f(a.id) = a.u.*((bt_Qref.*ct - bt_Pref.*st)./V - id)./Tp;

psat_obj.DAE.f(a.iq) = a.u.*((bt_Pref.*ct + bt_Qref.*st)./V - iq)./Tq;


