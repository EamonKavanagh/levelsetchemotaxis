close all; clear

n = 90; h = 2*pi/n;
t = (0:h:2*pi-h)';
x = cos(t)/3; y = .25*sin(t);
area0 = polyarea(x,y);
x = [x;x(1)]; y = [y;y(1)];
interfaceStruct = create_iso_int_struct(x,y);

for iter = 1:1000
    disp(['iteration: ' num2str(iter)])
    [p, t, in, ind] = construct_mesh(interfaceStruct,.05);

    interfaceStruct = attach_interface_inds(interfaceStruct, ind);
    
    e = boundedges(p,t);
    nm = length(p);
    
    [p, t] = add_P2_nodes(p,t);
    triStruct = create_tri_struct(p,t);
    
    [p, t, interfaceStruct] = update_iso_int_nodes(p,t,triStruct,interfaceStruct);
    p = update_iso_boundary_nodes(p, t, triStruct, e);
    
    [K, M, f] = assemble_matrices(p,t,in);
    
    U = (K+M)\f;
    
    velocityStruct = get_velocity(p, t, triStruct, interfaceStruct, U);
    disp(['Max velocity: ' num2str(max(abs(velocityStruct.V)))])
    interfaceStruct = update_front(velocityStruct);
    nodes = zeros(length(velocityStruct(1).nodes),2);
    nodes(1:2:end,:) = interfaceStruct(1).nodes;
    nodes(2:2:end-1,:) = interfaceStruct(1).velocityLocs;
    area = polyarea(nodes(:,1),nodes(:,2));
    areaPreserved = norm(area0 - area);
    disp(['Error in area: ' num2str(areaPreserved)])
    disp(' ')
    plot(nodes(:,1),nodes(:,2));
    axis('square')
    axis([-1 1 -1 1])
    hold on
    plot(x,y, 'r')
    hold off
    pause(.001)
end