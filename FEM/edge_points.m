function [e,index] = edge_points(p)

index = sqrt(sum(p.^2,2))>.999;
e = sort_by_angle(p(index,:));