Bus.con = [ ... 
  1  400  1  0  1  1;
  2  400  1  0  1  1;
 ];

Line.con = [ ... 
  1  2  100  400  60  0  0  0.01  0.1  0.001  0  0  0  0  0  1;
 ];

SW.con = [ ... 
  1  100  400  1  0  1.5  -1.5  1.1  0.9  0.8  1  1  1;
 ];

PV.con = [ ... 
  2  2  400  0.8  1  0.8  -0.2  1.1  0.9  1  1;
 ];

Dfig.con = [ ... 
  2  1  10  400  60  0.01  0.1  0.01  0.08  3  3  10  3  10  0.01  75  4  3  0.01123596  1  0  0.7  -0.7  1  1;
 ];

Wind.con = [ ... 
  2  15  1.225  0.1  0.1  20  2  5  15  1  5  15  25  50  0.01  0.2  50  10  1;
 ];

Bus.names = {... 
  'Bus1'; 'Bus2'};

