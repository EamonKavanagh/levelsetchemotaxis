function A = minmod(X,Y)

smallerAbs = abs(X) < abs(Y);
A = X.*smallerAbs + (1-smallerAbs).*Y;