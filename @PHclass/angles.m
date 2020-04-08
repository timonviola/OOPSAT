function [s12a,c12a] = angles(a,psat_obj)

alpha  = psat_obj.DAE.x(a.alpha);
t1 = psat_obj.DAE.y(a.bus1);
t2 = psat_obj.DAE.y(a.bus2);

s12a = sin(t1-t2-alpha);
c12a = cos(t1-t2-alpha);
