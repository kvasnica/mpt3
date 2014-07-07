function test_polyunion_outerapprox_06_pass
% tests correctness of the outer approximation

% 1D
P1 = Polyhedron('lb', -2, 'ub', -1);
P2 = Polyhedron('lb', 0, 'ub', 1);
P3 = Polyhedron('lb', 2, 'ub', 3);
U = PolyUnion([P1 P2 P3]);
B = U.outerApprox();
Bexp = Polyhedron('lb', -2, 'ub', 3);
assert(isa(B, 'Polyhedron'));
assert(numel(B)==1);
assert(B==Bexp);

% 2D
P1 = Polyhedron([0 0; 0 1; 1 0; 1 1]);
P2 = Polyhedron([2 2; 2 3; 3 2; 3 3]);
U = PolyUnion([P1 P2]);
B = U.outerApprox();
Bexp = Polyhedron([0 0; 0 3; 3 0; 3 3]);
assert(isa(B, 'Polyhedron'));
assert(numel(B)==1);
assert(B==Bexp);

end
