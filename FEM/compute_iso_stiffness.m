function kh = compute_iso_stiffness(nodes)

[pts, weight] = gauss_quad_pts(6);
quadx = pts(:,1); quady = pts(:,2);
numQuadPts = length(quadx);
%Gradient of shape function evaluated at Gauss quadrature points (9 pt)
gradGamma = [-3+4*quadx+4*quady,-3+4*quadx+4*quady;
            4*quadx-1, 0*quady;
            0*quadx, 4*quady-1;
            4*quady, 4*quadx;
            -4*quady, 4-4*quadx-8*quady;
            4-4*quady-8*quadx, -4*quadx];
J = zeros(numQuadPts,4);
for i = 1:6
    j  = (i-1)*numQuadPts+1;
    J = J + kron(nodes(i,:),gradGamma(j:j+numQuadPts-1,:));
end
detJ = (J(:,1).*J(:,4)-J(:,2).*J(:,3));
JinvT = [J(:,4) -J(:,3) -J(:,2), J(:,1)]./kron(ones(1,4),detJ);

kh = zeros(6);
for i = 1:6
    for j = 1:6
        i1 = (i-1)*numQuadPts+1;
        j1 = (j-1)*numQuadPts+1;
        gi = gradGamma(i1:i1+numQuadPts-1,:);
        gix = gi(:,1); giy = gi(:,2);
        gj = gradGamma(j1:j1+numQuadPts-1,:);
        gjx = gj(:,1); gjy = gj(:,2);
        top = (JinvT(:,1).*gix+JinvT(:,2).*giy).*(JinvT(:,1).*gjx+JinvT(:,2).*gjy);
        bot = (JinvT(:,3).*gix+JinvT(:,4).*giy).*(JinvT(:,3).*gjx+JinvT(:,4).*gjy);
        kh(i,j) = ((top+bot).*abs(detJ))'*weight;
    end
end
