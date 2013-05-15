function test_polyunion_min_06_pass
% test for PolyUnion/min with piecewise constant functions

P1 = Polyhedron('V', [0; 2]);
P2 = Polyhedron('V', [1; 3]);
P1.addFunction(AffFunction(0, 1), 'obj');
P2.addFunction(AffFunction(0, 2), 'obj');
PU1 = PolyUnion('Set', P1, 'overlaps', false);
PU2 = PolyUnion('Set', P2, 'overlaps', false);
PUs = [PU1 PU2];
out = PUs.min('obj');
out.fplot([], [], 'linewidth', 3); axis([0 3 0.9 2.1]);
assert(out.Num==2);
assert(isequal(sortrows(out.Set(1).V), [0; 2]));
assert(isequal(sortrows(out.Set(2).V), [2; 3]));
assert(isequal(out.Set(1).Func{1}.F, 0));
assert(isequal(out.Set(1).Func{1}.g, 1));
assert(isequal(out.Set(2).Func{1}.F, 0));
assert(isequal(out.Set(2).Func{1}.g, 2));


end
