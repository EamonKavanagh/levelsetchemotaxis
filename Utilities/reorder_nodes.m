function [nodes, order] = reorder_nodes(nodes, node2, node3)

inds = [2 3; 3 1; 1 2];
[~, ind2] = ismember(node2, nodes(1:3,:), 'rows');
[~, ind3] = ismember(node3, nodes(1:3,:), 'rows');
ind1 = setxor([1 2 3], [ind2 ind3]);
ind4 = find(all((ind2 == inds) + (ind3 == inds), 2))+3;
ind5 = find(all((ind3 == inds) + (ind1 == inds), 2))+3;
ind6 = find(all((ind1 == inds) + (ind2 == inds), 2))+3;

nodes = nodes([ind1 ind2 ind3 ind4 ind5 ind6],:);
order = [ind1 ind2 ind3 ind4 ind5 ind6];