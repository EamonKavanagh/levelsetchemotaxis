function V = extend_velocity(V, phi, h, numTimeSteps)

dt = h/5;

sgn = phi./sqrt(phi.^2+h^2);
Dphix = ([phi(:,2:end), phi(:,1)] - [phi(:,end), phi(:,1:end-1)])/(2*h);
Dphiy = ([phi(2:end,:); phi(1,:)] - [phi(end,:); phi(1:end-1,:)])/(2*h);
normGradPhi = sqrt(Dphix.^2+Dphiy.^2 + h^2);
upwindx = sgn.*Dphix./normGradPhi;
upwindy = sgn.*Dphiy./normGradPhi;
posX = upwindx > 0;
posY = upwindy > 0;

%3rd order TVD RK scheme
for i = 1:numTimeSteps
    LV = extension_operator(V, h, upwindx, posX, upwindy, posY);
    V1 = V + dt*LV;
    
    LV = extension_operator(V1, h, upwindx, posX, upwindy, posY);
    V2 = 3*V/4 + V1/4 + dt*LV/4;
    
    LV = extension_operator(V2, h, upwindx, posX, upwindy, posY);
    V = V/3 + 2*V2/3 + 2*dt*LV/3;
end