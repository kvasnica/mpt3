function test_polyunion_min_11_pass
% single 1D polyunion with overlapping regions

% the output should be 3 regions:
%   [-4, -1]: f=2
%   [-1,  1]: f=1
%   [ 4,  1]: f=2
G1 = Polyhedron('lb', -4, 'ub', -1);
G2 = Polyhedron('lb', -1, 'ub', 1);
G3 = Polyhedron('lb', 1, 'ub', 4);

%% zero affine terms
P1 = Polyhedron('lb', -4, 'ub', 4);
P1.addFunction(AffFunction(0, 2), 'f');
P2 = Polyhedron('lb', -1, 'ub', 1);
P2.addFunction(AffFunction(0, 1), 'f');
U = PolyUnion([P1 P2]);
M = U.min();
assert(M.Num==3);
assert(M.Set == [G1 G2 G3]);
% double-check that there are no overlaps
assert(~PolyUnion(M.Set).isOverlapping);

%% non-zero, but identical affine terms
% (fixed in eef3fbc7a996)
P1 = Polyhedron('lb', -4, 'ub', 4);
P1.addFunction(AffFunction(-1, 2), 'f');
P2 = Polyhedron('lb', -1, 'ub', 1);
P2.addFunction(AffFunction(-1, 1), 'f');
U = PolyUnion([P1 P2]);
M = U.min();
assert(M.Num==3);
assert(M.Set == [G1 G2 G3]);
% double-check that there are no overlaps
assert(~PolyUnion(M.Set).isOverlapping);

%% non-zero, different affine terms
% (fixed in eef3fbc7a996)
P1 = Polyhedron('lb', -4, 'ub', 4);
P1.addFunction(AffFunction(-1, 2), 'f');
P2 = Polyhedron('lb', -1, 'ub', 1);
P2.addFunction(AffFunction(1, 1), 'f');
U = PolyUnion([P1 P2]);
M = U.min();
assert(M.Num==3);
assert(M.Set == [G1 G2 G3]);
% double-check that there are no overlaps
assert(~PolyUnion(M.Set).isOverlapping);

end
