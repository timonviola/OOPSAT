function [Cda,Cdb,Cdc,Dda,Ddb,Ddc] = costs(a,psat_obj)


Cda = a.u.*a.con(:,8)/psat_obj.Settings.mva;
Cdb = a.u.*a.con(:,9);
Cdc = psat_obj.Settings.mva*a.u.*a.con(:,10);

Dda = a.u.*a.con(:,11)/psat_obj.Settings.mva;
Ddb = a.u.*a.con(:,12);
Ddc = psat_obj.Settings.mva*a.u.*a.con(:,13);
