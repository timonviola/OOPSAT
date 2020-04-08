function warn(a,idx,msg,psat_obj)

psat_obj.fm_disp(fm_strjoin('Warning: JIMMA LOAD #',int2str(idx),' at bus <', ...
    psat_obj.Bus.names(a.bus(idx)),'>: ',msg))