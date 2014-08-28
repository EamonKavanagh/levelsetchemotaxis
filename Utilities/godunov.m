function [fluxm, fluxp] = godunov(Dxm, Dxp, Dym, Dyp)

fluxxm = max(min(Dxm,0).^2,max(Dxp,0).^2);
fluxym = max(min(Dym,0).^2,max(Dyp,0).^2);
fluxxp = max(max(Dxm,0).^2,min(Dxp,0).^2);
fluxyp = max(max(Dym,0).^2,min(Dyp,0).^2);
fluxm = sqrt(fluxxm + fluxym);
fluxp = sqrt(fluxxp + fluxyp);