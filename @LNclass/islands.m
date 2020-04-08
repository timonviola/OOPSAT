function islands(a,psat_obj)

if ~a.n, return, end

% looking for islanded buses
traceY = abs(sum(a.Y).'-diag(a.Y));
traceY = gettrace(psat_obj.Ltc,traceY);
traceY = gettrace(psat_obj.Phs,traceY);
traceY = gettrace(psat_obj.Hvdc,traceY);
traceY = gettrace(psat_obj.Lines,traceY);

psat_obj.Bus = islands(psat_obj.Bus,traceY);
