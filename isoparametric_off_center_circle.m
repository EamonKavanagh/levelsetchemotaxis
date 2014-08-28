close all; clear

N = 200;
H = 2/(N-1);
[X,Y] = meshgrid(-1:H:1,-1:H:1);
phi = @(x,y) 4*sqrt((x-.25).^2+(y-.25).^2)-1;
phi = phi(X,Y);
phi = reinitialize_level_set(phi, H, 200);
phi0 = phi;

n = 100; h = 2*pi/n;
t = (0:h:2*pi-h)';
x = .25*cos(t)+.25; y = .25*sin(t)+.25;
x = [x;x(1)]; y = [y;y(1)];
x0 = x; y0 = y;
area0 = polyarea(x,y);

for iter = 101:150
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
    phi = evolve_interface(V, phi, H, 1);
    phi = reinitialize_level_set(phi, H, 10);
    levelSet = contour(X,Y,phi,[0,0]);
    levelStruct = split_level_set(levelSet);
    [x,y] = interpolate_level_set(levelStruct, n);
    result(iter).x = x; result(iter).y = y;
    result(iter).area = polyarea(x,y);
    plot(x,y)
    axis('square')
    axis([-.5+.25 .5+.25 -.5+.25 .5+.25])
    hold on
    contour(X,Y,phi0,[0,0],'r')
    hold off
    pause(.001)
end
