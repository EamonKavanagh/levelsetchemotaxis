function velocityStruct = compute_interface_velocity(p, t, triStruct, interfaceStruct, U)

velocityStruct = struct('V', [], 'normal', [], 'nodes', [], 'inds',[], 'grad', []);

for i = 1:length(interfaceStruct)
    velLocs = interfaceStruct(i).velocityLocs;
    inds = interfaceStruct(i).velocityInds;
    intInds = interfaceStruct(i).interfaceInds;
    n = length(velLocs);
    velocityStruct(i).inds = zeros(2*n+1,1);
    velocityStruct(i).inds(1:2:end) = intInds;
    velocityStruct(i).inds(2:2:end-1) = inds;
    V = zeros(n,1);
    normal = zeros(n,2);
    grad = zeros(n,2);
    inds = [inds(end);inds;inds(1)];
    intNodes = interfaceStruct(i).nodes;
    intNodes = [intNodes(end-1,:); intNodes; intNodes(2,:)];
    for j = 2:n+1
        node1 = intNodes(j-1,:);
        node2 = intNodes(j,:);
        node3 = intNodes(j+1,:);
        node4 = intNodes(j+2,:);
        tri = min(triStruct(inds(j)).triangles);
        tri2 = min(triStruct(inds(j+1)).triangles);
        tri1 = min(triStruct(inds(j-1)).triangles);
        [verts, ord] = reorder_nodes(p(t(tri,:),:), node2, node3);
        [verts2, ord2] = reorder_nodes(p(t(tri2,:),:), node3, node4);
        [verts1, ord1] = reorder_nodes(p(t(tri1,:),:), node1, node2);
%         verts = p(t(tri,:),:);
%         verts2 = p(t(tri2,:),:);
%         verts1 = p(t(tri1,:),:);
        
        v2 = compute_iso_velocity(verts2, 1/2, 1/2, U(t(tri2,ord2)));
        v1 = compute_iso_velocity(verts1, 1/2, 1/2, U(t(tri1,ord1)));
        arclength = compute_iso_arc_length(verts, 0, 1);
        arclength2 = compute_iso_arc_length(verts2, 0, 1/2);
        arclength1 = compute_iso_arc_length(verts1, 1/2, 1);
        arclength = arclength1+arclength+arclength2;
        V(j-1) = -(v2-v1)/arclength;
        [~, nor] = compute_iso_tan_normal(verts, 1/2);
        normal(j-1,:) = nor;
        grad(j-1,:) = compute_iso_gradient(verts, 1/2, 1/2, U(t(tri,ord)));
    end
    velocityStruct(i).grad = grad;
    velocityStruct(i).nodes = zeros(2*n+1,2);
    velocityStruct(i).nodes(2:2:end-1,:) = velLocs;
    velocityStruct(i).nodes(1:2:end,:) = interfaceStruct(i).nodes;
    
    velocityStruct(i).V = zeros(2*n+1,1);
    velocityStruct(i).V(2:2:end-1) = V;
    pts = [velLocs, V]';
    curve = cscvn([pts, pts(:,1)]);
    tVals = (curve.breaks(1:end-1)+curve.breaks(2:end))/2;
    interpV = ppval(curve, tVals);
    interpV = [interpV(3,end), interpV(3,:)];
    velocityStruct(i).V(1:2:end) = interpV;
    
    velocityStruct(i).normal = zeros(2*n+1,2);
    velocityStruct(i).normal(2:2:end-1,:) = normal;
    curve = cscvn([normal; normal(1,:)]');
    tVals = (curve.breaks(1:end-1)+curve.breaks(2:end))/2;
    interpNormal = ppval(curve, tVals);
    interpNormal = [interpNormal(1:2,end), interpNormal(1:2,:)];
    velocityStruct(i).normal(1:2:end,:) = interpNormal';
end