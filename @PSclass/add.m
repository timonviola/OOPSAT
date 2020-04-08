function a = add(a,data,psat_obj)

a.n = a.n + length(data(1,:));
a.con = [a.con; data];
a.exc = [a.exc; data(:,1)];
a.syn = psat_obj.Exc.syn(a.exc);
a.bus = getbus(psat_obj.Syn,a.syn);
a.vbus= a.bus + psat_obj.Bus.n;

