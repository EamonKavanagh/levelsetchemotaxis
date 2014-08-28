function [p,t] = add_P2_nodes(p,t)
%ADD_P2_NODES a 2-D mesh refinement to find the additional nodes and
%triangle numbers required for P2 elements for the FEM.
%
%   [p,t] = quadratic_elements(p,t)
%   quadratic_elements addes additional nodes and triangle numbers to an 
%   existing tessalation in a consistent fashion by calculating the 
%   midpoints of each each triangle side.

n = length(p);

%pNew needs to be initialized with something for ismember to work.
vertices = p(t(1,:),:);
pNew = (vertices([2 3 1],:)+vertices([3 1 2],:))/2;

tNew = zeros(size(t));
for i = 1:length(t)
    vertices = p(t(i,:),:);
    midPts = (vertices([2 3 1],:)+vertices([3 1 2],:))/2;
    [bool, ind] = ismember(midPts,pNew,'rows');
    for j = 1:3
        if bool(j) == 1
            tNew(i,j) = ind(j) + n;
        else
            tNew(i,j) = size(pNew,1) + n + 1;
            pNew = [pNew; midPts(j,:)];
        end
    end
end
p = [p;pNew];
t = [t,tNew];