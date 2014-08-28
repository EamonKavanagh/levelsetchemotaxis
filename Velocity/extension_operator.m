function LV = extension_operator(V, h, upwindx, posX, upwindy, posY)

%extension_operator contains the discretized spatial terms in the extension
%velocity equation dV/dt = -sgn(phi)*(grad phi/|grad phi|)*(grad V).  The
%upwind and pos terms indicate proper upwind direction.

[Dxm, Dxp, Dym, Dyp] = upwindFirst(V, h);


%Godunov
Dupx = posX.*Dxm + (1-posX).*Dxp;
Dupy = posY.*Dym + (1-posY).*Dyp;

LV = -(Dupx.*upwindx + Dupy.*upwindy);