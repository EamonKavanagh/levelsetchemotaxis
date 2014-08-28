function [t,A] = make_consistent_numbering(inIndex,outIndex,t)

%Updates the triangle numbering to patch the two tesselations together.
%inIndex are the triangle numbers in t corresponding to the interface that 
%need to be updated and ind2 are the values they need to be updated with.

A = zeros(size(t));
for i = 1:length(inIndex)
    A(t>inIndex(i)) = A(t>inIndex(i)) - 1;
    A(t==inIndex(i)) = 0;
    t(t==inIndex(i)) = outIndex(i);
end
t = t+A;