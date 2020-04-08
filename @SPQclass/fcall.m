function fcall(a,psat_obj)

if ~a.n, return, end

id = psat_obj.DAE.x(a.id);
iq = psat_obj.DAE.x(a.iq);

V = psat_obj.DAE.y(a.vbus);
t = psat_obj.DAE.y(a.bus);
st = sin(t);
ct = cos(t);

bt_Pref = a.con(:,2)./psat_obj.DAE.mva;
bt_Qref = a.con(:,3)./psat_obj.DAE.mva;

Tp = a.con(:,4);
Tq = a.con(:,5);


psat_obj.DAE.f(a.id) = a.u.*((bt_Qref.*ct - bt_Pref.*st)./V - id)./Tp;

psat_obj.DAE.f(a.iq) = a.u.*((bt_Pref.*ct + bt_Qref.*st)./V - iq)./Tq;


