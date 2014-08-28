close all; clear

N = 200;
H = 2/(N-1);
[X,Y] = meshgrid(-1:H:1,-1:H:1);
phi1 = @(x,y) 4*sqrt((x+.35).^2 + y.^2)-1;
phi1 = phi1(X,Y);
phi2 = @(x,y) 4*sqrt((x-.35).^2 + y.^2)-1;
phi2 = phi2(X,Y);
phi = min(phi1,phi2);
phi = reinitialize_level_set(phi, H, 500);
phi0 = phi;

n = 100; h = 2*pi/n;
t = (0:h:2*pi-h)'+h;
x = .25*cos(t); y = .25*sin(t);
x = [x;x(1)]; y = [y;y(1)];
x = [x+.35, x-.35]; y = [y, y];
n = 2*n;

for iter = 1:120
    disp(['iter = ' num2str(iter)])
    interfaceStruct = create_iso_int_struct(x,y);
    [p,t,in,ind] = construct_mesh(interfaceStruct,.05);
    
    interfaceStruct = attach_interface_inds(interfaceStruct, ind);

    e = boundedges(p,t);
    nm = length(p);
    
    [p,t] = add_P2_nodes(p,t);
    triStruct = create_tri_struct(p,t);
    [p, t, interfaceStruct] = update_iso_int_nodes(p,t,triStruct,interfaceStruct);
    p = update_iso_boundary_nodes(p, t, triStruct, e);
    
    [K,M,f] = assemble_matrices(p,t,in);
    
    U = (K+M)\f;
    
    velocityStruct = compute_interface_velocity(p, t, triStruct, interfaceStruct, U);
    u = fem_ext_vel(p, t, velocityStruct, triStruct);
    V = interpolate_velocity_to_grid(phi, X, Y, velocityStruct, u, p, t, triStruct);
    V = extend_velocity(V, phi, H, 10);
    pause
    phi = evolve_interface(V, phi, H, 1);
    phi = reinitialize_level_set(phi, H, 10);
    levelSet = contour(X,Y,phi,[0,0]);
    %levelSet = cubic_contour(phi, X, Y);
    %levelSet = [[0; length(levelSet)], levelSet'];
    levelStruct = split_level_set(levelSet);
    [x,y] = interpolate_level_set(levelStruct, n);
    plot(x,y)
    axis('square')
    axis([-.8 .8 -.8 .8])
    hold on
    contour(X,Y,phi0,[0,0],'r')
    hold off
    result(iter).x = x;
    result(iter).y = y;
    pause(.001)
end