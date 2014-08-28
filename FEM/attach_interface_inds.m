function interfaceStruct = attach_interface_inds(interfaceStruct, ind)

for i = 1:length(interfaceStruct)
    n = length(interfaceStruct(i).nodes);
    j = (i-1)*(n-1)+1;
    interfaceStruct(i).interfaceInds = [ind(j:j+n-2);ind(j)];
end