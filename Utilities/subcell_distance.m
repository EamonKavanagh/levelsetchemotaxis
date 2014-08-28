function distance = subcell_distance(gridData, h, eps)

%Forward, backward, and centered differences
deltaxp = abs([gridData(:,2:end), gridData(:,1)] - gridData);
deltaxm = abs(gridData - [gridData(:,end), gridData(:,1:end-1)]);
deltaxc = .5*abs([gridData(:,2:end), gridData(:,1)] - [gridData(:,end), gridData(:,1:end-1)]);
deltayp = abs([gridData(2:end,:); gridData(1,:)] - gridData);
deltaym = abs(gridData - [gridData(end,:); gridData(1:end-1,:)]);
deltayc = .5*abs([gridData(2:end,:); gridData(1,:)] - [gridData(end,:); gridData(1:end-1,:)]);

%Choose maximum over the three and a small parameter for robustness
deltax = max(deltaxp, max(deltaxc, max(deltaxm, eps)));
deltay = max(deltayp, max(deltayc, max(deltaym, eps)));

delta = sqrt(deltax.^2+deltay.^2);

distance = h*gridData./delta;