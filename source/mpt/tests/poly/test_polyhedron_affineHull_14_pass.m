function test_polyhedron_affineHull_14_pass
% only implicit equalities

% Polyhedron(A, b)
A = [1 0; -1 0];
b = [0; 0];
P = Polyhedron(A, b);
[Hea, Ha] = P.affineHull();
Hea_exp = [-1 0 0];
assert(isempty(Ha));
assert(norm(Hea-Hea_exp)<1e-6);

% Polyhedron('H', H)
H = [1 0 0; -1 0 0];
P = Polyhedron('H', H);
[Hea, Ha] = P.affineHull();
Hea_exp = [-1 0 0];
assert(isempty(Ha));
assert(norm(Hea-Hea_exp)<1e-6);

end
