function sortedPoints = sort_by_angle(points)

len=length(points);
center = sum(points)/len;

%Finds the corresponding angle theta
angle=atan2(points(:,2)-center(2),points(:,1)-center(1));

%Sorts based on the angle
[~,sorted_inds]=sort(angle);
sortedPoints = [points(sorted_inds,1), points(sorted_inds,2)];
