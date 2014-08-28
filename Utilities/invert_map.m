function [s,t] = invert_map(nodes, x, y)
xn = nodes(:,1); yn = nodes(:,2);
N = @(s,t) [(1-s-t)*(1-2*s-2*t);
            s*(2*s-1);
            t*(2*t-1);
            4*s*t;
            4*t*(1-s-t);
            4*s*(1-s-t)]';
g = @(s,t) [N(s,t)*xn-x; N(s,t)*yn-y];

Ns = @(s,t) [-3+4*s+4*t;
             4*s-1;
             0
             4*t;
             -4*t;
             4-4*t-8*s]';
         
Nt = @(s,t) [-3+4*s+4*t;
             0;
             4*t-1
             4*s;
             4-4*s-8*t;
             -4*s]';
J = @(s,t) [Ns(s,t)*xn, Nt(s,t)*xn; Ns(s,t)*yn, Nt(s,t)*yn];

oldST = [1/2; 1/2];
tol = 1e-12;
err = 1;
while err > tol;
    delta = -J(oldST(1),oldST(2))\g(oldST(1),oldST(2));
    newST = oldST + delta;
    err = norm(g(newST(1),newST(2)));
    oldST = newST;
end

s = oldST(1); t = oldST(2);