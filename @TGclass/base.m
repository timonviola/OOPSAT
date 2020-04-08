function p = base(p,psat_obj)
%converts revice parameters to system power and voltage bases
if ~p.n, return, end
for i = 1:p.n
    if (p.con(i,2) == 1) || (p.con(i,2) == 2),
         p.con(i,4) = psat_obj.Settings.mva.*p.con(i,4)./getvar(psat_obj.Syn,p.syn(i),'mva');
         p.con(i,5) = p.con(i,5).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,6) = p.con(i,6).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
    end 
    if (p.con(i,2) == 3),
         p.con(i,5) = p.con(i,5).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,6) = p.con(i,6).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,7) = p.con(i,7).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,8) = p.con(i,8).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,11) = p.con(i,11).*psat_obj.Settings.mva./getvar(psat_obj.Syn,p.syn(i),'mva');
    end
    if (p.con(i,2) == 4),
         p.con(i,5) = p.con(i,5).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,6) = p.con(i,6).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,7) = p.con(i,7).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,8) = p.con(i,8).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,11) = p.con(i,11).*psat_obj.Settings.mva./getvar(psat_obj.Syn,p.syn(i),'mva');
    end
    if (p.con(i,2) == 5),
         p.con(i,5) = p.con(i,5).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,6) = p.con(i,6).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,7) = p.con(i,7).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,8) = p.con(i,8).*getvar(psat_obj.Syn,p.syn(i),'mva')/psat_obj.Settings.mva;
         p.con(i,11) = p.con(i,11).*psat_obj.Settings.mva./getvar(psat_obj.Syn,p.syn(i),'mva');
    end
    if (p.con(i,2) == 6),
         p.con(i,16) = p.con(i,16).*psat_obj.Settings.mva./getvar(psat_obj.Syn,p.syn(i),'mva');
    end
end



    



