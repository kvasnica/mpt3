function test_polyunion_min_14_pass
% domains must be preserved

P1 = Polyhedron('V', [0; 2]);
P2 = Polyhedron('V', [1; 3]);
D1 = Polyhedron('lb', 0, 'ub', 1);
D2 = Polyhedron([1; 2]);
P1.addFunction(AffFunction(0, 1), 'obj');
P2.addFunction(AffFunction(0, 2), 'obj');
PU1 = PolyUnion('Set', P1, 'Domain', [D1 D2], 'overlaps', false);
PU2 = PolyUnion('Set', P2, 'overlaps', false);
PUs = [PU1 PU2];
out = PUs.min('obj');
% the domain must be composed of three polyhedra
assert(numel(out.Domain)==3);

% min() applied to a single polyunion must preserve its domain
D = Polyhedron('lb', 0, 'ub', 3);
U = PolyUnion('Set', [P1 P2], 'Domain', D);
out = U.min('obj');
assert(numel(out.Domain)==1);
assert(out.Domain==D);

end
