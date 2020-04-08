function warn(a, idx, msg,psat_obj)

global Bus

psat_obj.fm_disp(fm_strjoin('Warning: SVC #', int2str(idx), ' at bus <', ...
    psat_obj.Bus.names(a.bus(idx)), '>: ', msg))
