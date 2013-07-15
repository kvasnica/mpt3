function test_polyunion_saturation_01_pass
% tests Union/findSaturated

Punsat = Polyhedron('lb', -1, 'ub', 1);
Punsat.addFunction(AffFunction(1, 0), 'f');
Pmax = Polyhedron('lb', 1, 'ub', 2);
Pmax.addFunction(AffFunction(0, 1), 'f');
Pmin1 = Polyhedron('lb', -2, 'ub', -1);
Pmin1.addFunction(AffFunction(0, -1), 'f');
Pmin2 = Polyhedron('lb', -3, 'ub', -2);
Pmin2.addFunction(AffFunction(0, -1), 'f');

U = PolyUnion([Pmin1, Punsat, Pmax, Pmin2]);

% automatic saturation limits
out = U.findSaturated('f');
assert(isequal(out.S, [-1, 0, 1, -1]));
assert(isequal(out.Imin, [1 4]));
assert(isequal(out.Imax, 3));
assert(isequal(out.Iunsat, 2));

% manual saturation limits
out = U.findSaturated('f', 'min', -1, 'max', 1);
assert(isequal(out.S, [-1, 0, 1, -1]));
assert(isequal(out.Imin, [1 4]));
assert(isequal(out.Imax, 3));
assert(isequal(out.Iunsat, 2));

end
