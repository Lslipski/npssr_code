T = table()
for p = 1:size(DAT.npsresponse,2)
T = [ T cell2table(DAT.npsresponse(p), 'VariableNames',DAT.conditions(p))]
end

T = []
for p = 1:size(DAT.npsresponse,2)
    mat = [DAT.npsresponse{p}]
    mat(end+1:20,:)=nan    
    T = [T mat]
end


nps_table = array2table(T,'VariableNames',DAT.conditions)
