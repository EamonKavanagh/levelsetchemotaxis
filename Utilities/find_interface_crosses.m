function crossInt = find_interface_crosses(sgn)

%Use sign to evaluate whether a points neighbors cross the interface.
N = size(sgn, 1);

crossInt = [];
for j = 2:N-1
    for i = 2:N-1
        a = sgn(i,j)*sgn(i-1,j); b = sgn(i,j)*sgn(i+1,j);
        c = sgn(i,j)*sgn(i,j-1); d = sgn(i,j)*sgn(i,j+1);
        if any([a b c d] < 0)
            crossInt = [crossInt;[i,j]];
        end
    end
end