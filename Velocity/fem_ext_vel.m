function U = fem_ext_vel(p, t, velocityStruct, triStruct)

n = length(p);
K = zeros(n,n);
f = zeros(n,1);
for k = 1:length(t)
    nodes = p(t(k,:),:);
    kh = compute_iso_stiffness(nodes);
    K(t(k,:),t(k,:)) = K(t(k,:),t(k,:)) + kh;
end

for k = 1:length(velocityStruct)
    velInds = velocityStruct(k).inds;
    velocity = velocityStruct(k).V;
    K(velInds,:) = 0;
    K(velInds,velInds) = eye(length(velInds));
    f(velInds) = velocity;
    
    intInds = velInds(1:2:end);
    velInds = velInds(2:2:end-1);
    normJump = zeros(length(velInds), n);
    for i = 1:length(velInds)
        tris = sort(triStruct(velInds(i)).triangles);
        intNodes = [p(intInds(i),:); p(intInds(i+1),:)];
        for j = 1:2
            nodeNums = t(tris(j),:);
            [nodes, order] = reorder_nodes(p(nodeNums,:), intNodes(j,:), intNodes((j<2)+1,:));
            [~, normal] = compute_iso_tan_normal(nodes, 1/2);
            gradient = compute_iso_gradient2(nodes, 1/2, 1/2);
            normJump(i,nodeNums(order)) = normJump(i,nodeNums(order)) - 5*(gradient*normal')';
        end
    end
    K = [K; normJump];
    f = [f; zeros(length(velInds),1)];
end
U = K\f;