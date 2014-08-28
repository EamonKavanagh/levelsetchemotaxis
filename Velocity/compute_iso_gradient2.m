function gradient = compute_iso_gradient2(nodes, s, t)

J11 = [4*s+4*t-3, 4*s-1, 0, 4*t, -4*t, 4-4*t-8*s]*nodes(:,1);
J12 = [4*s+4*t-3, 0, 4*t-1, 4*s, 4-4*s-8*t, -4*s]*nodes(:,1);
J21 = [4*s+4*t-3, 4*s-1, 0, 4*t, -4*t, 4-4*t-8*s]*nodes(:,2);
J22 = [4*s+4*t-3, 0, 4*t-1, 4*s, 4-4*s-8*t, -4*s]*nodes(:,2);
JinvT = [J22 -J21; -J12 J11]/(J11*J22-J12*J21);

gradGamma = [4*s+4*t-3, 4*s-1, 0, 4*t, -4*t, 4-4*t-8*s;
             4*s+4*t-3, 0, 4*t-1, 4*s, 4-4*s-8*t, -4*s];
         
gradient = (JinvT*gradGamma)';