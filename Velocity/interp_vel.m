function velocity = interp_vel(s, t, u)

N = [(1-s-t)*(1-2*s-2*t);
     s*(2*s-1);
     t*(2*t-1);
     4*s*t;
     4*t*(1-s-t);
     4*s*(1-s-t)]';
velocity = N*u;