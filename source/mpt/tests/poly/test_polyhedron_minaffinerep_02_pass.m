function test_polyhedron_minaffinerep_02_pass
% only implicit equalities

% Polyhedron(A, b)
A = [1 0; -1 0];
b = [0; 0];
P = Polyhedron(A, b);
P.minAffineRep();
He_exp = [-1 0 0];
assert(isempty(P.H));
assert(norm(P.He-He_exp)<1e-6);

% Polyhedron('H', H)
A = [1 0; -1 0];
b = [0; 0];
P = Polyhedron('H', [A b]);
P.minAffineRep();
He_exp = [-1 0 0];
assert(isempty(P.H));
assert(norm(P.He-He_exp)<1e-6);


end
