function [Dxm, Dxp, Dym, Dyp] = upwindENO2(gridData, h)

hinv = 1/h;
% %Upwinding periodic BC
Dxm = hinv*(gridData - [gridData(:,end), gridData(:,1:end-1)]);
Dym = hinv*(gridData - [gridData(end,:); gridData(1:end-1,:)]);
Dxp = hinv*([gridData(:,2:end), gridData(:,1)] - gridData);
Dyp = hinv*([gridData(2:end,:); gridData(1,:)] - gridData);

%2nd order ENO
Dxx = hinv*(Dxp - Dxm);
Dyy = hinv*(Dyp - Dym);
Dxxm = [Dxx(:,end), Dxx(:,1:end-1)];
Dxxp = [Dxx(:,2:end), Dxx(:,1)];
Dyym = [Dyy(end,:); Dyy(1:end-1,:)];
Dyyp = [Dyy(2:end,:); Dyy(1,:)];

mxm = minmod(Dxx,Dxxm);
mxp = minmod(Dxx,Dxxp);
mym = minmod(Dyy,Dyym);
myp = minmod(Dyy,Dyyp);

Dxm = Dxm + h*mxm/2;
Dxp = Dxp - h*mxp/2;
Dym = Dym + h*mym/2;
Dyp = Dyp - h*myp/2;