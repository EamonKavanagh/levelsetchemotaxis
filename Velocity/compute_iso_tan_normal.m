function [tangent, normal] = compute_iso_tan_normal(nodes, s)

x = nodes(:,1); y = nodes(:,2);

tangent = -[s*(4*x(2)+4*x(3)-8*x(4)) + 4*x(4)-x(2)-3*x(3),...
            s*(4*y(2)+4*y(3)-8*y(4)) + 4*y(4)-y(2)-3*y(3)];
tangent = tangent/norm(tangent);
normal = [-tangent(2), tangent(1)];