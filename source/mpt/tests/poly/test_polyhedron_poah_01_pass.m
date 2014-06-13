function test_polyhedron_poah_01_pass
% tests Polyhedron/projectOnAffineHull()

% P = { x | 0.5 <= x_1 <= 1, x_2 = 0 }
P = Polyhedron('H', [1 0 1; -1 0 -0.5], 'He', [0 1 0]);
Q = P.projectOnAffineHull();
Hexp = [-1 1; 1 -0.5];
assert(Q.Dim==1);
assert(norm(Q.H - Hexp, Inf) < 1e-8);

end
