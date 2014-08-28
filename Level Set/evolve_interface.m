function phi = evolve_interface(V, phi, h, numTimeSteps)

dt = h/5;
%3rd order TVD RK scheme
for i = 1:numTimeSteps
    Lphi = evolution_operator(phi, h, V);
    phi1 = phi + dt*Lphi;
    
    Lphi = evolution_operator(phi1, h, V);
    phi2 = 3*phi/4 + phi1/4 + dt*Lphi/4;
    
    Lphi = evolution_operator(phi2, h, V);
    phi = phi/3 + 2*phi2/3 + 2*dt*Lphi/3;
end