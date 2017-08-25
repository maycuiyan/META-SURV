function e = CIEdges(y,c)

e = cell(length(c),1);
for i = 1:length(e)
    if c(i)==1
        e{i}(:,2) = find(y>y(i));
        e{i}(:,1) = i;
    end
end

e = cell2mat(e);
    