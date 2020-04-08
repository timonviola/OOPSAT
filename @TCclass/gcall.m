function gcall(a,psat_obj)

if ~a.n, return, end

V1 = psat_obj.DAE.y(a.v1);
V2 = psat_obj.DAE.y(a.v2);
t1 = psat_obj.DAE.y(a.bus1);
t2 = psat_obj.DAE.y(a.bus2);
ss = sin(t1-t2);
cc = cos(t1-t2);

% update B
B = btcsc(a,psat_obj);

P1 = V1.*V2.*ss.*B;

psat_obj.DAE.g = psat_obj.DAE.g ...
        + sparse(a.bus1,1,P1,psat_obj.DAE.m,1) ...
        - sparse(a.bus2,1,P1,psat_obj.DAE.m,1) ...
        + sparse(a.v1,1,V1.*(V1-V2.*cc).*B,psat_obj.DAE.m,1) ...
        + sparse(a.v2,1,V2.*(V2-V1.*cc).*B,psat_obj.DAE.m,1); 

tx = a.con(:,3) == 1;
t2 = a.con(:,3) == 2;
ta = a.con(:,4) == 2;   

x0 = a.X0;
x2 = zeros(a.n,1);
x2(find(t2)) = psat_obj.DAE.x(a.x2(find(t2)));
Pref = psat_obj.DAE.y(a.pref);

[Ps,Qs,Pr,Qr] = flows(psat_obj.Line,psat_obj,'pq',a.line);
[Ps,Qs,Pr,Qr] = flows(a,psat_obj,Ps,Qs,Pr,Qr,'tcsc');

Kp = a.con(:,12);

% x0 = -t2.*Kp.*(Pref-Ps-ta.*Pr) + x2;
% x0 = t2.*Kp.*(Pref-Ps-ta.*Pr) + x2;
x0 = tx.*x0 + t2.*(Kp.*(Pref-Ps-ta.*Pr) + x2);

psat_obj.DAE.g = psat_obj.DAE.g ...
        + sparse(a.x0,1,x0-psat_obj.DAE.y(a.x0),psat_obj.DAE.m,1) ...
        + sparse(a.pref,1,a.Pref-psat_obj.DAE.y(a.pref),psat_obj.DAE.m,1);

