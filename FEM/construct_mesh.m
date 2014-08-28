function [p,t,triInGamma,ind,phi] = construct_mesh(interfaceStruct,edgeLength)
%CIRCLES 2-D Mesh Generator for a circular domain with circular interfaces
%using distmesh.
%   [p,t, inner_tri, interface_nodes] = circles(x,y,r,edge_length)
%Circles triangulates a circular outer domain with N (length(x)) inner
%droplets of perscribed center & radius.


%Constructs the signed distance function for the interface.
phi = @(p) dpoly(p,interfaceStruct(1).nodes);
edgeNodes = interfaceStruct(1).nodes(1:end-1,:);

for i = 2:length(interfaceStruct)
    phi = @(p) dunion(phi(p),dpoly(p,interfaceStruct(i).nodes));
    edgeNodes = [edgeNodes; interfaceStruct(i).nodes(1:end-1,:)];
end

%Generates nodes and triangle numbers for Omega with Gamma removed
fd = @(p) ddiff(dcircle(p,0,0,1),phi(p));
fh = @(p) .1 + .2*phi(p);

[p,t] = distmesh2d(fd,fh,edgeLength,[-1,-1;1,1],edgeNodes);
triInGamma = length(t);

%Inner region
[p1,t1] = distmesh2d(phi,@huniform,edgeLength,[-1,-1;1,1],edgeNodes);

%Appends new points and triangle numbers
[~,inIndex] = ismember(edgeNodes,p1,'rows');
[~,outIndex] = ismember(edgeNodes,p,'rows');
pMax = length(p);
t1 = make_consistent_numbering(inIndex+pMax,outIndex,t1+pMax);
newNodes = ones(length(p1),1);
newNodes(inIndex) = 0;
newNodes = logical(newNodes);
ind = outIndex;
p = [p;p1(newNodes,:)];
t = [t;t1];