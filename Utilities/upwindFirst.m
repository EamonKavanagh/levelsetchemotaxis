function [Dxm, Dxp, Dym, Dyp] = upwindFirst(gridData, h)

hinv = 1/h;
% %Upwinding periodic BC
Dxm = hinv*(gridData - [gridData(:,end), gridData(:,1:end-1)]);
Dym = hinv*(gridData - [gridData(end,:); gridData(1:end-1,:)]);
Dxp = hinv*([gridData(:,2:end), gridData(:,1)] - gridData);
Dyp = hinv*([gridData(2:end,:); gridData(1,:)] - gridData);