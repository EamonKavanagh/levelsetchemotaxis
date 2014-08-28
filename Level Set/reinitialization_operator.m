function Lphi = reinitialization_operator(phi, h, sgn, pos, dist, crossInt)

%reinitialization_operator contains the discretized spatial terms in the
%reinitialization equation dphi/dt = sgn(phi0)(1 - |grad phi|) with subcell 
%fix.  The pos term is for proper upwinding.

hinv = 1/h;
[Dxm, Dxp, Dym, Dyp] = upwindENO2(phi, h);

[fluxm, fluxp] = godunov(Dxm, Dxp, Dym, Dyp);

%Upwinding for 1 - |grad phi| term in reinitialization equation
G = (pos).*(fluxp-1) + (1-pos).*(fluxm-1);
Lphi = -sgn.*G;

%Subcell fix
for k = 1:size(crossInt,1)
    i = crossInt(k,1); j = crossInt(k,2);
    Lphi(i,j) = -hinv*(sgn(i,j).*abs(phi(i,j))-dist(i,j));
end