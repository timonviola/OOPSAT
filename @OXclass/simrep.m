function simrep(a, blocks, masks, lines,psat_obj)


if ~a.n, return, end

typeidx = find(strcmp(masks,'Oxl'));

for h = 1:length(typeidx)
  line_out = find_system(lines,'SrcBlockHandle',blocks(typeidx(h)));
  v_out = ['Voxl = ',fvar(psat_obj.DAE.x(a.v(h)),7),' p.u.'];
  set_param(line_out,'Name',v_out);
end

