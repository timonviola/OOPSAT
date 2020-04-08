function windup(p,psat_obj)

csi_max = p.con(:, 10);
csi_min = p.con(:, 11);

fm_windup(p.csi, csi_max, csi_min, 'td',psat_obj)
