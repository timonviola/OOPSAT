function growth(a,type,psat_obj)

rr = a.con(:,6)/100;

if sum(abs(rr)) < 1e-5
  fm_disp('Likely no annual growth has been defined.',2)
  return
end

switch type
 case 'area'
  idx = a.int(getarea(psat_obj.Bus,0,0));
 case 'region'
  idx = a.int(getregion(psat_obj.Bus,0,0));
end
    
ddata = growth(psat_obj.PQ,rr,idx);
sdata = growth(psat_obj.PV,rr,idx);
sdata = [sdata; growth(psat_obj.SW,rr,idx)];

psat_obj.Demand = remove(psat_obj.Demand,[1:psat_obj.Demand.n]);
psat_obj.Demand  = add(psat_obj.Demand,ddata);

psat_obj.Supply = remove(psat_obj.Supply,[1:psat_obj.Supply.n]);
psat_obj.Supply = add(psat_obj.Supply,sdata);

