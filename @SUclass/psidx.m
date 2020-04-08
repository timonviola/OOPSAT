function idx = psidx(a,k,psat_obj)

idx = sparse(a.bus,[1:a.n],k,psat_obj.Bus.n,a.n);

