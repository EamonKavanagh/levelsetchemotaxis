function levelStruct = split_level_set(levelSet)

levelStruct = struct('nodes', []);
i = 1;
j = 1;
while 1
    ind = levelSet(:,i);
    nodes = levelSet(:,i+1:i+ind(2));
    levelStruct(j).nodes = nodes;
    i = i+ind(2)+1;
    if i > length(levelSet)
        break
    end
    j = j+1;
end