function test_polyhedron_minus_19_pass
% polytope - empty set = polytope

X = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
W = Polyhedron.emptySet(X.Dim);
N = X-W;
assert(X==N);

end