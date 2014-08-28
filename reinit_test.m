clear; close all
A = 4; B = 2; eps = .1; x0 = -3.5; y0 = -2;
N = 200;
h = 10/(N-1);
[X,Y] = meshgrid(-5:h:5,-5:h:5);
f = eps + (X-x0).^2 + (Y-y0).^2;
phi = f.*(sqrt((X/A).^2 + (Y/B).^2)-1);
journalfig(2.5)
c = -2:.4:2;
contour(X,Y,phi,c);
xlabel('x')
ylabel('y')
title('Contour Lines for Skewed Level Set')
print('-depsc','skewedcontour')

phi = reinitialize_level_set(phi,h, 200);
journalfig(2.5)
contour(X,Y,phi,c);
xlabel('x')
ylabel('y')
title('Contour Lines Ater Reinitialization')
print('-depsc','correctedcontour')
