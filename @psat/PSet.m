% PSet(OBJ,SET_POINT_VECTOR) set all PG (obj.pv.store(:,PG) except slack 
%   generator and do NOT change VG values.
%   The internal sorting will assign the right values to each generator eg.:
%   define setpoints as [.3 .4 .2. .4, 1.1 1.01 1.02 .98]
%                       [    PG      ,        VG        ]
%   PSet will sort the psat generators and assign the
%   right values e.g: first generator wll be PG = .3, VG = no-change
%                     second gen      	     PG = .4, VG = no-change etc.
function PSet(obj, set_point_vector)
    
PG = 4;
nPG = size(obj.PV.store,1);

generatorData = obj.PV.store;
[~,sortIdx] = sort(generatorData(:,1));
generatorData(sortIdx,PG) = set_point_vector(1:nPG);
obj.PV.store = generatorData;
end