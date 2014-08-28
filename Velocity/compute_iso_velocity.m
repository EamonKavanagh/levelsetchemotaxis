function velocity = compute_iso_velocity(nodes, s, t, U)

grad = compute_iso_gradient(nodes, s, t, U);

[tangent, normal] = compute_iso_tan_normal(nodes, s);

Vs = tangent*grad;
Vn = normal*grad;
velocity = Vs/Vn;