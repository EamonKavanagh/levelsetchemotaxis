function p = update_iso_boundary_nodes(p, t, triStruct, e)

% for i = 1:length(e)-1
%     p1 = e(i,:); p2 = e(i+1,:);
%     x = (p1(1)+p2(1))/2;
%     y = (p1(2)+p2(2))/2;
%     [~,j] = ismember([x y],p(nm+1:end,:),'rows');
%     j = j+nm;
%     angle = rem(2*pi+atan2(y,x),2*pi);
%     x = cos(angle); y = sin(angle);
%     p(j,:) = [x y];
% end

for i = 1:length(e)
    num1 = e(i,1); num2 = e(i,2);
    tris1 = triStruct(num1).triangles;
    tris2 = triStruct(num2).triangles;
    tri = intersect(tris1,tris2);
    triVerts = p(t(tri,:),:);
    p1 = p(num1,:); p2 = p(num2,:);
    midPt = (p1 + p2)/2;
    [~,ind] = ismember(midPt, triVerts(4:6,:), 'rows');
    j = t(tri,ind+3);
    angle = rem(2*pi+atan2(midPt(2),midPt(1)),2*pi);
    x = cos(angle); y = sin(angle);
    p(j,:) = [x,y];
end