function settings(obj)

obj.Settings.absvalues = 'off';
obj.Settings.beep = 0;
obj.Settings.checkdelta = 0;
obj.Settings.chunk = 100;
obj.Settings.coi = 0;
obj.Settings.conv = 1;
obj.Settings.date = 'January 6, 2013';
obj.Settings.deltadelta = 180;
obj.Settings.deltat = 6.2178e-17;
obj.Settings.deltatmax = 0.125;
obj.Settings.deltatmin = 0.00039063;
obj.Settings.distrsw = 0;
obj.Settings.donotask = 0;
obj.Settings.dynmit = 20;
obj.Settings.dyntol = 1e-05;
obj.Settings.error = 1;
obj.Settings.export = 'txt';
obj.Settings.fixt = 0;
obj.Settings.forcepq = 0;
obj.Settings.format = 2;
obj.Settings.freq = 50;
obj.Settings.hostver = 7.00;
obj.Settings.init = 1;
obj.Settings.iter = 4;
obj.Settings.lfmit = 20;
obj.Settings.lftime = 0.45836;
obj.Settings.lftol = 1e-05;
obj.Settings.local = 1;
obj.Settings.locksnap = 0;
obj.Settings.matlab = 1;
obj.Settings.maxvar = 1500;
obj.Settings.maxsimout = 15;
obj.Settings.maxsimin = 15;
obj.Settings.method = 2;
obj.Settings.mv = 1.117;
obj.Settings.mva = 100;
obj.Settings.multipvswitch = 0;
obj.Settings.noarrows = 1;
obj.Settings.nseries = 0;
obj.Settings.octave = 0;
obj.Settings.ok = 1;
obj.Settings.pfsolver = 1;
obj.Settings.platform = 'UNIX';
obj.Settings.plot = 0;
obj.Settings.plottype = 1;
obj.Settings.pq2z = 0;
obj.Settings.pv2pq = 0;
obj.Settings.pv2pqniter = 0;
obj.Settings.report = 0;
obj.Settings.resetangles = 1;
obj.Settings.show = 1;
obj.Settings.showlf = 0;
obj.Settings.simtd = 0;
obj.Settings.static = 0;
obj.Settings.status = 1;
obj.Settings.switch2nr = 0;
obj.Settings.t0 = 0;
obj.Settings.tf = 20;
obj.Settings.tstep = 0.05;
obj.Settings.tviewer = '!cat ';
obj.Settings.usedegree = 0;
obj.Settings.usehertz = 0;
obj.Settings.userelspeed = 0;
obj.Settings.version = '2.1.7';
obj.Settings.violations = 'off';
obj.Settings.vs = 0;
obj.Settings.xlabel = 'time (s)';
obj.Settings.zoom = '';

obj.Theme.color01 = [0.68235     0.69804     0.76471];
obj.Theme.color02 = [0.68235     0.69804     0.76471];
obj.Theme.color03 = [0.44314      0.5451     0.64706];
obj.Theme.color04 = [0.94118     0.92549     0.88235];
obj.Theme.color05 = [0  0  0];
obj.Theme.color06 = [1  1  1];
obj.Theme.color07 = [0.75           0           0];
obj.Theme.color08 = [0.69804     0.30196     0.47843];
obj.Theme.color09 = [1  1  1];
obj.Theme.color10 = [1  1  1];
obj.Theme.color11 = [0.94118     0.92549     0.88235];

if strncmp(computer,'PC',2) && usejava('jvm')
  obj.Theme.font01 = 'Helvetica';
  obj.Theme.font02 = 'Helvetica';
  obj.Theme.font03 = 'Helvetica';
  obj.Theme.font04 = 'Helvetica';
else
  obj.Theme.font01 = 'Arial';
  obj.Theme.font02 = 'Arial';
  obj.Theme.font03 = 'Arial';
  obj.Theme.font04 = 'Arial'; 
end

obj.Theme.hdl = zeros(18,1);
