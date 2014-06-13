function test_polyhedron_affinehull_11_pass
% tests Polyhedron/affineHull()

% the re-computed affine hull must be equal to the original (if it isn't,
% we have a bug in Polyhedron/chebyCenter related to issue #113)
He = [0 1 0];
H = [1 0 1; -1 0 -0.5];
P = Polyhedron('H', H, 'He', He);
A = P.affineHull();
assert(isequal(A, He));

% equalities embedded as double-sided inequalities
P = Polyhedron('H', [H; He; -He]);
A = P.affineHull();
assert(isequal(A, He) || isequal(A, -He));

end
