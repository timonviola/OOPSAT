% PVSet(OBJ,SET_POINT_VECTOR) set all PG (obj.pv.store(:,PG) except slack 
%   generator and all VG values (including slack).
%   The internal sorting will assign the right values to each generator eg.:
%   define setpoints as [.3 .4 .2. .4, 1.1 1.01 1.02 .98]
%                       [    PG      ,        VG        ]
%   PVSet will sort the psat generators and assign the
%   right values e.g: first generator wll be PG = .3, VG = 1.1
%                     second gen      	     PG = .4, VG = 1.01 etc.
function PVSet(obj, set_point_vector)
    
    PG = 4; VG = 5;
    nPG = size(obj.PV.store,1);
    generatorData = obj.PV.store;
    [~,sortIdx] = sort(generatorData(:,1));
    generatorData(sortIdx,PG) = set_point_vector(1:nPG);
    slackData = obj.SW.store;
    % set slack voltage!
    slackData(4) = set_point_vector(nPG+1); 
    generatorData(sortIdx,VG) = set_point_vector(nPG+2:end);
    % re-assign modified values to psat obj
    obj.SW.store = slackData;
    obj.PV.store = generatorData;
end