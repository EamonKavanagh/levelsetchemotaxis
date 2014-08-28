function interfaceStruct = track_front(velocityStruct, h)

dt = h/20;
interfaceStruct = struct('nodes',[],'interfaceInds',[],'velocityInds',[], 'velocityLocs', []);

for i = 1:length(velocityStruct)
    nodes = velocityStruct(i).nodes;
    V = velocityStruct(i).V;
    normal = velocityStruct(i).normal;
    nodes = nodes - dt*normal.*[V, V];    
    interfaceStruct(i).nodes = nodes(1:2:end,:);
    interfaceStruct(i).velocityLocs = nodes(2:2:end-1,:);
end