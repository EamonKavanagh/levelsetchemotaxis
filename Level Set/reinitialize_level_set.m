function phi = reinitialize_level_set(phi,h, numTimeStep)

dt = h/5;

%Initialize sign(phi), subcell distance, upwinding and interface crosses as
%they are all based upon phi0.
sgn = sign(phi);
pos = phi > 0;
dist = subcell_distance(phi, h, 1e-10);
crossInt = find_interface_crosses(sgn);

%3rd order TVD-Runge Kutta
for i = 1:numTimeStep
    Lphi = reinitialization_operator(phi, h, sgn, pos, dist, crossInt);
    phi1 = phi + dt*Lphi;
    
    Lphi = reinitialization_operator(phi1, h, sgn, pos, dist, crossInt);
    phi2 = 3*phi/4 + phi1/4 + dt*Lphi/4;
    
    Lphi = reinitialization_operator(phi2, h, sgn, pos, dist, crossInt);
    phi = phi/3 + 2*phi2/3 + 2*dt*Lphi/3;
end