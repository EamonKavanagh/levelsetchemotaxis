function Lphi = evolution_operator(phi, h, V)

%evolution_operator contains the discretized spatial terms in the level set
%equation dphi/dt = -V|grad phi|.

[Dxm, Dxp, Dym, Dyp] = upwindENO2(phi, h);

[fluxm, fluxp] = godunov(Dxm, Dxp, Dym, Dyp);

%Upwinding for -V*|grad phi| term in level set equation
Vp = max(V,0);
Vm = min(V,0);
Lphi = -(Vp.*fluxp + Vm.*fluxm);