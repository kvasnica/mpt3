function test_polyunion_foreach_01_pass

P = Polyhedron('lb', [-1; -1], 'ub', [1; 1]);
Q = Polyhedron('lb', [-4; -4], 'ub', [0; 0]);
R = Polyhedron('lb', [1; -1], 'ub', [2; 1]);
U1 = PolyUnion(Polyhedron([R P]));
U2 = PolyUnion(Polyhedron([R P Q]));
Z = [U1 U2];

% uniform outputs
out = Z.forEach(@isConvex);
assert(isequal(out, [1 0]));

% non-uniform outputs requested
out = Z.forEach(@isConvex, 'UniformOutput', false);
assert(iscell(out));
assert(length(out)==2);
assert(isequal(cat(2, out{:}), [1 0]));

end
