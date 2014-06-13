function test_polyhedron_poah_02_pass
% Polyhedron/projectOnAffineHull() with affine sets

% projection of { x \in R^3 | x_2 = 0 } is R^2
P = Polyhedron('He', [0 1 0 0]);
Q = P.projectOnAffineHull();
assert(Q.Dim==2);
assert(Q.isFullSpace());

% projection of { x \in R^3 | x_2 <= 0, x_2 >= 0 } is R^2
P = Polyhedron('H', [0 1 0 0; 0 -1 0 0]);
Q = P.projectOnAffineHull();
assert(Q.Dim==2);
assert(Q.isFullSpace());

% projection of { x \in R^3 | x_2 = 0, x_1 + x_3 = 1 } is R^2
P = Polyhedron('He', [0 1 0 0; 1 0 0 1]);
Q = P.projectOnAffineHull();
assert(Q.Dim==1);
assert(Q.isFullSpace());

end
