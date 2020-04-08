function a = setup(a,psat_obj)

if ~psat_obj.Settings.coi, return, end
if ~psat_obj.Syn.n, return, end

% get generator parameters
ng = [1:psat_obj.Syn.n]';
a.M = getvar(psat_obj.Syn,ng,'M');
coi = getvar(psat_obj.Syn,ng,'COI');
gen = getbus(psat_obj.Syn,ng);

% determine generator groups
coi_groups = unique(coi);
a.n = length(coi_groups);

% check for islands in generator groups
[buses,nisland] = fm_flows(psat_obj,'connectivity');

if nisland > 1

  % intersections of islands and COI areas
  island = zeros(a.n,1);
  for j = 1:a.n 
    ntemp = 0;
    idx = find(coi == coi_groups(j));
    for i = 1:nisland
      temp = intersect(gen(idx),buses{i});
      if length(temp) > ntemp
        ntemp = length(temp);
        island(j) = i;
      end
    end
  end

  % set up COI parameters
  n_coi = 0;
  a.gen = [];
  for i = 1:a.n
    if island(i)
      n_coi = n_coi+1;
      idx = find(coi == coi_groups(i));
      [dummy,gdx,bdx] = intersect(gen(idx),buses{island(i)});
      k = idx(gdx);
      a.Mtot(n_coi,1) = sum(a.M(k));
      a.syn{n_coi,1} = k;
      a.gen = [a.gen; k];     
    end
  end
  
  a.gen = sort(a.gen);
  a.M = a.M(a.gen);
  a.n = n_coi;

else

  % set up COI parameters
  a.gen = ng;
  for i = 1:a.n
    idx = find(coi == coi_groups(i));
    a.Mtot(i,1) = sum(a.M(idx));
    a.syn{i,1} = idx;
  end

end  

