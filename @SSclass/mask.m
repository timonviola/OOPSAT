function [x,y,s] = mask(a,idx,orient,vals)

[xc,yc] = fm_draw('circle','Sssc',orient);
[xr,yr] = fm_draw('cap','Sssc',orient);
[xa,ya] = fm_draw('acdc2','Sssc',orient);

x = cell(12,1);
y = cell(12,1);
s = cell(12,1);

x{1} = [0.3 0.3 -0.95 -0.95 0.3];
y{1} = [-1.7 2.7 2.7 -1.7 -1.7];
s{1} = 'k';

x{2} = [-0.75 -0.75 -0.4];
y{2} = [-1.7 -5 -5];
s{2} = 'k';

x{3} = [0.1 0.1 -0.25];
y{3} = [-1.7 -5 -5];
s{3} = 'k';

x{4} = [-0.4 -0.4];
y{4} = [-4 -6];
s{4} = 'k';

x{5} = -0.15+0.1*xr;
y{5} = -5+yr;
s{5} = 'k';

x{6} = [-0.325 -0.325];
y{6} = [2.7 3.5];
s{6} = 'k';

x{7} = [-0.575 -0.95];
y{7} = [5.9 5.9];
s{7} = 'k';

x{8} = [-0.075 0.3];
y{8} = [5.9 5.9];
s{8} = 'k';

x{9} = 0;
y{9} = 17.8;
s{9} = 'w';

x{10} = 0.25*xc-0.325;
y{10} = 4.5+yc;
s{10} = 'k';

x{11} = 0.25*xc-0.325;
y{11} = 5.9+yc;
s{11} = 'k';

x{12} = xa;
y{12} = ya;
s{12} = 'm';

[x,y] = fm_maskrotate(x,y,orient);
