function a = intervention(a,t,psat_obj)

persistent angles voltages

if ~a.n, return, end

% do not repeat computations if the simulation is stucking
if a.time ~= t
  a.time = t;
else
  return
end
  
for i = 1:a.n
  
  h = a.bus(i);
  
  if t == a.con(i,5) % fault occurrence
    
    fm_disp(['Applying fault(s) at bus <', ...
             psat_obj.Bus.names{h},'> for t = ',num2str(t),' s'])
    
    % enable fault
    a.u(i) = 1; 
    
    % store pre-fault bus angles
    angles = psat_obj.DAE.y(psat_obj.Bus.a);
    voltages = psat_obj.DAE.y([psat_obj.Bus.n+1:end]);
    
    % update algebraic variables
    %conv = fm_nrlf(40,1e-4,1,0);
    
  elseif t == a.con(i,6) % fault clearance
    
    fm_disp(['Clearing fault(s) at bus <', ...
             psat_obj.Bus.names{h},'> for t = ',num2str(t),' s'])
    
    % disable fault
    a.u(i) = 0; 
    
    % recover bus voltages
    %psat_obj.DAE.y(psat_obj.Bus.n+1:2*psat_obj.Bus.n) = ones(psat_obj.Bus.n,1);
    %psat_obj.DAE.y(getbus(PV,'v')) = getvg(PV,'all');
    %psat_obj.DAE.y(getbus(SW,'v')) = getvg(SW,'all');
    psat_obj.DAE.y([psat_obj.Bus.n+1:end]) = voltages;
    if psat_obj.Settings.resetangles
      psat_obj.DAE.y(psat_obj.Bus.a) = angles;
    end

    % update algebraic variables
    %conv = fm_nrlf(40,1e-4,1,1);
    
  end
  
end
