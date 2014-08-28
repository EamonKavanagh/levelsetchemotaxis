function [X,Y] = interpolate_level_set(levelStruct, N)
X = zeros(N/length(levelStruct)+1,length(levelStruct));
Y = X;
for i = 1:length(levelStruct)
    curve = cscvn(levelStruct(i).nodes);
    h = curve.breaks(end)/(N/length(levelStruct));
    t = 0:h:curve.breaks(end);
    pts = ppval(curve,t);
    X(:,i) = pts(1,:); Y(:,i) = pts(2,:);
end
X(end,:) = X(1,:);
Y(end,:) = Y(1,:);