function V = interpolate_velocity_to_grid(phi, X, Y, velocityStruct, u, p, t, triStruct)

N = size(phi,1);
V = zeros(N);

for i = 1:length(velocityStruct)
    vel = velocityStruct(i).V;
    nodes = velocityStruct(i).nodes;
    velocityStruct(i).curve = cscvn([nodes, vel]');
end
sgn = sign(phi);

for j = 2:N-1
    for i = 2:N-1
        if abs(phi(i,j)) < .05
            [~, ind] = min((p(:,1)-X(i,j)).^2 + (p(:,2)-Y(i,j)).^2);
            tris = triStruct(ind).triangles;
            for k = 1:length(tris)
                tri = tris(k);
                nodeNums = t(tri,:);
                nodes = p(nodeNums,:);
                if inpolygon(X(i,j), Y(i,j), nodes([1 6 2 4 3 5],1), nodes([1 6 2 4 3 5],2))
                    [ss,tt] = invert_map(nodes, X(i,j), Y(i,j));
                    velocity = interp_vel(ss, tt, u(nodeNums));
                    V(i,j) = velocity;
                    break
                end
            end
             %V(i,j) = griddata(p(:,1),p(:,2),u,X(i,j),Y(i,j),'cubic');
        end
%         sgn0 = sgn(i,j);
%         a = sgn0*sgn(i+1,j); b = sgn0*sgn(i-1,j);
%         c = sgn0*sgn(i,j-1); d = sgn0*sgn(i,j+1);
%         sgnChange = [a b c d] < 0;
%         
%         if any(sgnChange)
%             dist = [Inf Inf Inf Inf]; v = [0 0 0 0];
%             x = X(i,j); y = Y(i,j);
%             intDist = Inf;
%             for k = 1:length(velocityStruct)
%                 int = velocityStruct(k).nodes;
%                 [newDist, xp, yp] = p_poly_dist(x, y, int(:,1),int(:,2));
%                 if newDist < intDist
%                     intDist = newDist;
%                     nodes = int;
%                     proj = [xp yp];
%                     curve = velocityStruct(k).curve;
%                 end
%             end
%             for k = 1:4
%                 if sgnChange(k)
%                     const = (k > 2) + 1; change = (k < 3) + 1;
%                     [distance, velocity] = sethian_extension([x y], proj, nodes, const, change, curve);
%                     dist(k) = distance;
%                     v(k) = velocity;
%                 end
%             end
%             [tDist, tInd] = min(dist(1:2)); tDist = 1/tDist^2;
%             [sDist, sInd] = min(dist(3:4)); sDist = 1/sDist^2;
%             velocity = (tDist*v(tInd) + sDist*v(sInd+2))/(tDist+sDist);
%             V(i,j) = velocity;
%         end
    end
end