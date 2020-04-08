function simrep(a, blocks, masks, lines,psat_obj)

if ~a.n, return, end

typeidx = find(strcmp(masks,'SW'));

for h = 1:length(typeidx)
  line_out = find_system(lines,'SrcBlockHandle',blocks(typeidx(h)));
  v_out = ['P = ',fvar(psat_obj.Bus.Pg(a.bus(h)),7),' p.u. ->',char(10), ...
      'Q = ',fvar(psat_obj.Bus.Qg(a.bus(h)),7),' p.u. ->'];
  set_param(line_out,'Name',v_out);
end

