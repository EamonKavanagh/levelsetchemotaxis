function V = curvature_velocity(phi, h)


Dxx = ([phi(:,end), phi(:,1:end-1)] - 2*phi + [phi(:,2:end), phi(:,1)])/(h^2);
Dyy = ([phi(end,:); phi(1:end-1,:)] - 2*phi + [phi(2:end,:); phi(1,:)])/(h^2);
Dx = (-[phi(:,end), phi(:,1:end-1)] + [phi(:,2:end), phi(:,1)])/(2*h);
Dy = (-[phi(end,:); phi(1:end-1,:)] + [phi(2:end,:); phi(1,:)])/(2*h);
Dxy = (-[Dx(end,:); Dx(1:end-1,:)] + [Dx(2:end,:); Dx(1,:)])/(2*h);

V = -(Dxx.*Dy.^2 - 2*Dx.*Dy.*Dxy + Dyy.*Dx.^2)./(Dx.^2+Dy.^2+h.^2).^(3/2);