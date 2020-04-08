function y = admittance(a,psat_obj)


x = a.con(:,13);
r = a.con(:,14);
z = r+i*x;
y = 1./z;
