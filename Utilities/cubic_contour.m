function zeroContour = cubic_contour(gridData, X, Y)
%A zero contour recovery program that uses cubic interpolation

N = size(gridData, 1);
t = -1:2;
zeroContour = [];
sgn = sign(gridData);
for j = 2:N-1
    for i = 2:N-1
        sgn0 = sgn(i,j);
        a = sgn0*sgn(i+1,j); b = sgn0*sgn(i-1,j);
        c = sgn0*sgn(i,j-1); d = sgn0*sgn(i,j+1);
        e = sgn0*sgn(i+1,j-1); f = sgn0*sgn(i+1,j+1);
        g = sgn0*sgn(i-1,j-1); h = sgn0*sgn(i-1,j+1);
        sgnChange = [a b c d e f g h] < 0;
        if any(sgnChange) && gridData(i,j) > 0
            if sgnChange(1)
                y = Y(i-1:i+2, j);
                z = gridData(i-1:i+2, j);
                p = polyfit(y,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>y(2) & r<y(3));
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; X(i,j), r];
            end
            if sgnChange(2)
                y = Y(i-2:i+1, j);
                z = gridData(i-2:i+1, j);
                p = polyfit(y,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>y(2) & r<y(3));
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; X(i,j), r];
            end
            if sgnChange(3)
                x = X(i, j-2:j+1);
                z = gridData(i, j-2:j+1);
                p = polyfit(x,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>x(2) & r<x(3));
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; r, Y(i,j)];
            end
            if sgnChange(4)
                x = X(i, j-1:j+2);
                z = gridData(i, j-1:j+2);
                p = polyfit(x,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>x(2) & r<x(3));
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; r, Y(i,j)];
            end
            x1 = X(i,j); y1 = Y(i,j);
            if sgnChange(5)
                x0 = X(i+1,j-1); y0 = Y(i+1,j-1);
                z = [gridData(i+2,j-2) gridData(i+1, j-1) gridData(i,j) gridData(i-1,j+1)];
                p = polyfit(t,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>0 & r < 1);
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; r*(x1-x0)+x0, r*(y1-y0)+y0];
            end
            if sgnChange(6)
                x0 = X(i+1,j+1); y0 = Y(i+1,j+1);
                z = [gridData(i+2,j+2) gridData(i+1, j+1) gridData(i,j) gridData(i-1,j-1)];
                p = polyfit(t,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>0 & r < 1);
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; r*(x1-x0)+x0, r*(y1-y0)+y0];
            end
            if sgnChange(7)
                x0 = X(i-1,j-1); y0 = Y(i-1,j-1);
                z = [gridData(i-2,j-2) gridData(i-1, j-1) gridData(i,j) gridData(i+1,j+1)];
                p = polyfit(t,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>0 & r < 1);
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; r*(x1-x0)+x0, r*(y1-y0)+y0];
            end
            if sgnChange(8)
                x0 = X(i-1,j+1); y0 = Y(i-1,j+1);
                z = [gridData(i-2,j+2) gridData(i-1, j+1) gridData(i,j) gridData(i+1,j-1)];
                p = polyfit(t,z,3);
                r = roots(p);
                if ~isreal(r)
                    [~,ind] = min(abs(imag(r)));
                    r = real(r(ind));
                else
                    ind = find(r>0 & r < 1);
                    r = r(ind(1));
                end
                zeroContour = [zeroContour; r*(x1-x0)+x0, r*(y1-y0)+y0];
            end
        end
    end
end
zeroContour = sort_by_angle(zeroContour);
zeroContour = [zeroContour; zeroContour(1,:)];
