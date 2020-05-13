% GENLIST Get all generator bus numbers.
%
% gens = GENLIST Return all generator bus numbers
%   in a column vector. The slack bus is the first
%   element.
function gens = genlist(obj)
    slack = obj.SW.store;
    pvgen = obj.PV.store;
    gens = slack(:,1);
    gens = [gens;pvgen(:,1)];
end