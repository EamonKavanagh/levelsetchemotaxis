function interfaceStruct = create_iso_int_struct(X, Y)

interfaceStruct = struct('nodes',[],'interfaceInds',[],'velocityInds',[], 'velocityLocs', []);

for i = 1:size(X,2);
    interfaceStruct(i).nodes = [X(1:2:end,i),Y(1:2:end,i)];
    interfaceStruct(i).velocityLocs = [X(2:2:end,i),Y(2:2:end,i)];
end