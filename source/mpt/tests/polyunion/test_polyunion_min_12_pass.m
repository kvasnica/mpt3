function test_polyunion_min_12_pass
% single 2D polyunion with overlapping regions

% zero affine terms
P1 = Polyhedron('lb', [-4; -4], 'ub', [4; 4]);
P1.addFunction(AffFunction([0 0], 2), 'f');
P2 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2.addFunction(AffFunction([0 0], 1), 'f');
U = PolyUnion([P1 P2]);
M = U.min();
assert(M.Num==5);
G = [P1\P2, P2];
assert(M.Set == G);
% double-check that there are no overlaps
assert(~PolyUnion(M.Set).isOverlapping);

% non-zero affine terms, but both identical
% (fixed in eef3fbc7a996)
P1 = Polyhedron('lb', [-4; -4], 'ub', [4; 4]);
P1.addFunction(AffFunction(1e-1*[1 1], 2), 'f');
P2 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2.addFunction(AffFunction(1e-1*[1 1], 1), 'f');
U = PolyUnion([P1 P2]);
M = U.min();
assert(M.Num==5);
G = [P1\P2, P2];
assert(M.Set == G);
% double-check that there are no overlaps
assert(~PolyUnion(M.Set).isOverlapping);

% non-zero affine terms, but different
P1 = Polyhedron('lb', [-4; -4], 'ub', [4; 4]);
P1.addFunction(AffFunction(1e-1*[1 1], 2), 'f');
P2 = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
P2.addFunction(AffFunction(1e-1*[-1 -1], 1), 'f');
U = PolyUnion([P1 P2]);
M = U.min();
assert(M.Num==5);
G = [P1\P2, P2];
assert(M.Set == G);
% double-check that there are no overlaps
assert(~PolyUnion(M.Set).isOverlapping);

end
