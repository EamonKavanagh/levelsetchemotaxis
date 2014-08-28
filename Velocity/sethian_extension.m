function [distance, velocity] = sethian_extension(pt, proj, nodes, const, change, curve)

j = 1;
breakInd = zeros(2,1);
distance = Inf;
velocity = 0;
x = nodes(:,const) < pt(const);
if ~any(x)
    x = nodes(:,const) < proj(const);
end

for i = 1:length(x)-1
    if x(i) ~= x(i+1)
        breakInd(j) = i;
        j = j+1;
    end
end

if any(breakInd)
    [~, ind] = min(abs(pt(change)-nodes(breakInd, change)));
    breakInd = breakInd(ind);
else
    return
end


coefs = curve.coefs(3*(breakInd-1)+const,:);
coefs(4) = coefs(4)-pt(const);
t0 = curve.breaks(breakInd);
t1 = curve.breaks(breakInd+1);
r = roots(coefs);
if ~isreal(r)
    [~,ind] = min(abs(imag(r)));
    r = real(r(ind));
else
    ind = find(r>-eps & r<(t1-t0)+eps);
    r = r(ind(1));
end
interpValues = ppval(curve, r+t0);
distance = abs(pt(change) - interpValues(change));
velocity = interpValues(3);