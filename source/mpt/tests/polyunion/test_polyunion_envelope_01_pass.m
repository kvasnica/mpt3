function test_polyunion_envelope_01_pass

% bounded envelope
P1 = Polyhedron([0 0; 0 1; 1 1; 1 0]);
P2 = Polyhedron([1 1; 1 0; 2 0; 2 1]);
U = PolyUnion([P1 P2]);
E = U.envelope();
assert(E.isFullDim());
assert(E==[P1 P2]);

% unbounded envelope
P1 = Polyhedron([0 0; 0 1; 1 1; 1 0]);
P2 = Polyhedron([1 1; 1 0; 2 0; 2 2]);
U = PolyUnion([P1 P2]);
E = U.envelope();
assert(E>=U.convexHull);
assert(E.isFullDim());
assert(~E.isFullSpace());

end
