function test_polyhedron_affineHull_13_pass
% affine hull on a Vrep with 2 outputs must compute Hrep

V = eye(2);
R = [1 0];
P = Polyhedron('V', V, 'R', R);
[He, H] = P.affineHull();
H_exp = [-1 -1 -1;0 -1 0;0 1 1];
assert(isempty(He));
assert(norm(sortrows(H)-H_exp)<1e-6);

end
