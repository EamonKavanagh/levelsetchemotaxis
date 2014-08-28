function [p, t, interfaceStruct] = update_iso_int_nodes(p, t, triStruct, interfaceStruct)

for j = 1:length(interfaceStruct)
    n = length(interfaceStruct(j).nodes)-1;
    ind = interfaceStruct(j).interfaceInds;
    interfaceStruct(j).velocityInds = zeros(n,1);
    for i = 1:n        
        node2 = interfaceStruct(j).nodes(i,:);
        node3 = interfaceStruct(j).nodes(i+1,:);
        trisNode2 = triStruct(ind(i)).triangles;
        trisNode3 = triStruct(ind(i+1)).triangles;
        triOutside = min(intersect(trisNode2, trisNode3));
        triInside = max(intersect(trisNode2, trisNode3));
        
        tempNode4 = (node2+node3)/2;
        [~,tempNode4Ind] = ismember(tempNode4, p(t(triOutside,4:6),:),'rows');
        nodeNum = t(triOutside, tempNode4Ind+3);
        isoNode = interfaceStruct(j).velocityLocs(i,:);
        p(nodeNum,:) = isoNode;
        interfaceStruct(j).velocityInds(i) = nodeNum;
        
%         %Reorder local node numbering for outside
%         nodes = p(t(triOutside,:),:);
%         node1 = setxor(nodes(1:3,:),[node2;node3],'rows');
%         node5 = (node3+node1)/2; node6 = (node1+node2)/2;
%         orderedNodes = [node1;node2;node3;isoNode;node5;node6];
%         [~,index] = ismember(orderedNodes,nodes,'rows');
%         t(triOutside,:) = t(triOutside,index);
%         
%         %Reorder local node numbering for inside
%         temp = node2; node2 = node3; node3 = temp;
%         nodes = p(t(triInside,:),:);
%         node1 = setxor(nodes(1:3,:),[node2;node3],'rows');
%         node5 = (node3+node1)/2; node6 = (node1+node2)/2;
%         orderedNodes = [node1;node2;node3;isoNode;node5;node6];
%         [~,index] = ismember(orderedNodes,nodes,'rows');
%         t(triInside,:) = t(triInside,index);
    end
end

