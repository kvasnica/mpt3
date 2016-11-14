function test_polyhedron_17_pass
% empty polyhedron = empty vertices and rays

P = Polyhedron([1; -1], [-1; 0]);
assert(isempty(P.V));
assert(isempty(P.R));
assert(P.isEmptySet);

% random data
P = Polyhedron(randn(24,2),randn(24,1));
Q = Polyhedron('V',P.V,'R',P.R);
assert(isempty(P.V));
assert(isempty(P.R));
assert(isempty(Q.V));
assert(isempty(Q.R));
assert(Q.isEmptySet);
assert(P.isEmptySet);

end
