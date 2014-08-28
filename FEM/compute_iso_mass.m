function mh = compute_iso_mass(nodes)
[pts, weight] = gauss_quad_pts(5);
quadx = pts(:,1)'; quady = pts(:,2)';
numQuadPts = length(quadx);
%Shape function evaluated at Gauss quadrature points (7 pt)
gamma = [(1-quadx-quady).*(1-2*quadx-2*quady);
    quadx.*(2*quadx-1);
    quady.*(2*quady-1);
    4*quadx.*quady;
    4*quady.*(1-quadx-quady);
    4*quadx.*(1-quadx-quady)];
quadx = quadx';
quady = quady';
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
detJ = abs(J(:,1).*J(:,4)-J(:,2).*J(:,3))';

mh = zeros(6);
for i = 1:6
    for j = 1:6
        mh(i,j) = gamma(i,:).*gamma(j,:).*detJ*weight;
    end
end
