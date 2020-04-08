function a = add(a,data,psat_obj)


a.n = a.n + length(data(1,:));
a.con = [a.con; data];
a.line = [a.line; a.con(:,1)];
a.bus1 = [a.bus1; psat_obj.Line.fr(a.line)];
a.bus2 = [a.bus2; psat_obj.Line.to(a.line)];
a.v1 = a.bus1 + psat_obj.Bus.n;
a.v2 = a.bus2 + psat_obj.Bus.n;
