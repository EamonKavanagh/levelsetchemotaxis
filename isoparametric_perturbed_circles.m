close all; clear

N = 200;
H = 2/(N-1);
[X,Y] = meshgrid(-1:H:1,-1:H:1);
[theta1, r1] = cart2pol(X+.45,Y);
[theta2, r2] = cart2pol(X-.45,Y);

points = 6;
shift = 12;
scale = 0.02;
phi1 = r1 - scale * (cos(points * theta1) + shift);
phi2 = r2 - scale * (cos(points * theta2) + shift);
phi = min(phi1,phi2);
phi = improved_reinit_level_set(phi, H, 500);
phi0 = phi;

levelSet = contour(X,Y,phi,[0,0]);
levelStruct = split_level_set(levelSet);
n = 200;
[x,y] = interpolate_level_set(levelStruct, n);


i = 1;
for iter = 1:35
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
    
    V = interpolate_velocity_to_grid(phi, p, t, U, triStruct, interfaceStruct, N, X, Y);
    V = construct_extension_velocity(V, phi, H);
    phi = evolve_interface(V, phi, H, 1);
    phi = improved_reinit_level_set(phi, H, 10);
    levelSet = contour(X,Y,phi,[0,0]);
    levelStruct = split_level_set(levelSet);
    [x,y] = interpolate_level_set(levelStruct, n);
    subplotStruct(iter).x = x;
    subplotStruct(iter).y = y;
end
plot(x,y)
hold on
contour(X,Y,phi0,[0,0],'r')
hold off
