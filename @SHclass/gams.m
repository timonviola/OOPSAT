function [Gh,Bh,Ghc,Bhc] = gams(a,method,Gh,Bh,Ghc,Bhc,psat_obj)

if ~a.n, return, end

nb = psat_obj.Bus.n;

if method ~= 1
  Gh = Gh + sparse(a.bus,a.bus,a.u.*a.con(:,5),nb,nb);
  Bh = Bh + sparse(a.bus,a.bus,a.u.*a.con(:,6),nb,nb);
end  

if method == 4 || method == 6 || method == 7
  Ghc = Ghc + sparse(a.bus,a.bus,a.u.*a.con(:,5),nb,nb);
  Bhc = Bhc + sparse(a.bus,a.bus,a.u.*a.con(:,6),nb,nb);
end
