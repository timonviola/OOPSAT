function fcall(p,psat_obj)

if ~p.n, return, end

vcs = psat_obj.DAE.x(p.vcs);
ty3 = find(p.con(:,2) == 3);

if ty3   
  global Line
  [Ps,Qs,Pr,Qr] = flows(Line,psat_obj,'pq',p.line);
  [Ps,Qs,Pr,Qr] = flows(p,psat_obj,Ps,Qs,Pr,Qr,'sssc');
  Kin = p.con(:,12);
  tp = ty3(find(p.con(ty3,10) == 1));
  ta = ty3(find(p.con(ty3,10) == 2));    
  if tp
    psat_obj.DAE.f(p.vpi(tp)) = p.u(tp).*Kin(tp).*(psat_obj.DAE.y(p.pref(tp))-Ps(tp));
  end
  if ta
    psat_obj.DAE.f(p.vpi(ta)) = p.u(ta).*Kin(ta).*(psat_obj.DAE.y(p.pref(ta))-Ps(ta)-Pr(ta));
  end
end

psat_obj.DAE.f(p.vcs) = p.u.*(psat_obj.DAE.y(p.v0)-vcs)./p.con(:,7);

% anti-windup limit
fm_windup(p.vcs,p.con(:,8),p.con(:,9),'f',psat_obj)
