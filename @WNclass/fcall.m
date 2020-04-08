function fcall(a,psat_obj)

if ~a.n, return, end

psat_obj.DAE.f(a.vw) = (psat_obj.DAE.y(a.ws)-psat_obj.DAE.x(a.vw))./a.con(:,4);
