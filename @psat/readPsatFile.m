function readPsatFile(obj,fileName)
% READPSATFILE reads the data file defined by FILENAME into the current
% PSAT instance.

% load data
run(fileName)

% assign values to object properties
listVars = who;
for i=1:length(listVars)
    if(~ismember(listVars{i},{'fileName','obj'})) % except: fileName obj
        % For each field of the struct
        curFieldNames = fieldnames(eval(listVars{i}));
        for fn=1:length(curFieldNames)
           obj.(listVars{i}).(curFieldNames{fn}) = eval([listVars{i},'.',curFieldNames{fn}]); 
        end
    end
end

end