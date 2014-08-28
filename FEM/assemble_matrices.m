function [K,M,f] = assemble_matrices(p, t, in)

n = length(p);
K = zeros(n,n);
M = zeros(n,n);
f = zeros(n,1);

for k = 1:length(t)
    nodes = p(t(k,:),:);
    kh = compute_iso_stiffness(nodes);
    mh = compute_iso_mass(nodes);
    K(t(k,:),t(k,:)) = K(t(k,:),t(k,:)) + kh;
    M(t(k,:),t(k,:)) = M(t(k,:),t(k,:)) + mh;
    if k > in
        fh = compute_iso_rhs(nodes);
        f(t(k,:)) = f(t(k,:)) + fh;
    end
end