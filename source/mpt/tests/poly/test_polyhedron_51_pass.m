function test_polyhedron_51_pass
% do not fullify inputs (issue #130)

P = Polyhedron(sparse([1 0; 0 1; -1 0; 0 -1]), sparse([1; 1; 0; 0]));
assert(issparse(P.A));
assert(issparse(P.b));
assert(issparse(P.H));

P = Polyhedron('A', sparse([1 0; 0 1; -1 0; 0 -1]), 'b', sparse([1; 1; 0; 0]));
assert(issparse(P.A));
assert(issparse(P.b));
assert(issparse(P.H));

P = Polyhedron(sparse([1 0; 0 1; -1 0; 0 -1]), [1; 1; 0; 0]);
assert(issparse(P.A));
assert(issparse(P.b));
assert(issparse(P.H));

P = Polyhedron([1 0; 0 1; -1 0; 0 -1], sparse([1; 1; 0; 0]));
assert(issparse(P.A));
assert(issparse(P.b));
assert(issparse(P.H));

P = Polyhedron([1 0; 0 1; -1 0; 0 -1], [1; 1; 0; 0]);
assert(~issparse(P.A));
assert(~issparse(P.b));
assert(~issparse(P.H));

end
