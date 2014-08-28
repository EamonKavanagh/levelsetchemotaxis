close all; clear

N = 200;
H = 2/(N-1);
[X,Y] = meshgrid(-1:H:1,-1:H:1);
phi = @(x,y) sqrt(4*x.^2+16*y.^2)-1;
phi = phi(X,Y);
phi = reinitialize_level_set(phi, H, 100);
phi0 = phi;

n = 170; h = 2*pi/n;
t = (0:h:2*pi-h)'+h;
x = cos(t)/2; y = sin(t)/4;
area0 = polyarea(x,y);
circle0 = [cos(t) sin(t)];
x = [x;x(1)]; y = [y;y(1)];
x0 = x; y0 = y;
interfaceStruct = create_iso_int_struct(x,y);

for iter = 1:180
    disp(['iter = ' num2str(iter)])
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
    if iter < 20
        u = fem_ext_vel(p, t, velocityStruct, triStruct);
        V = interpolate_velocity_to_grid(phi, X, Y, velocityStruct, u, p, t, triStruct);
        V = extend_velocity(V, phi, H, 25);
        disp(['max V = ' num2str(max(max(abs(V))))])
        phi = evolve_interface(V, phi, H, 1);
        phi = reinitialize_level_set(phi, H, 10);
        levelSet = cubic_contour(phi, X, Y);
        levelSet = [[0; length(levelSet)], levelSet'];
        levelStruct = split_level_set(levelSet);
        [x,y] = interpolate_level_set(levelStruct, n);
        plot(x,y)
        axis('square')
        hold on
        contour(X,Y,phi0,[0,0])
        hold off
        pause(.001)
        area = polyarea(x,y);
        interfaceStruct = create_iso_int_struct(x,y);
    else
        interfaceStruct = track_front(velocityStruct, H);
        nodes = zeros(length(velocityStruct(1).nodes),2);
        nodes(1:2:end,:) = interfaceStruct(1).nodes;
        nodes(2:2:end-1,:) = interfaceStruct(1).velocityLocs;
        x = nodes(:,1); y = nodes(:,2);
        plot(x,y)
        hold on
        contour(X,Y,phi0,[0,0])
        hold off
        pause(.001)
        area = polyarea(x,y);
    end
    result(iter).x = x;
    result(iter).y = y;
    result(iter).area = norm(area0-area);
end
