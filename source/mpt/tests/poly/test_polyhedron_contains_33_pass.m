function test_polyhedron_contains_33_pass
% R^n contains any set

% empty set is contained any any non-empty set
E = Polyhedron.emptySet(2);
Pbounded = Polyhedron('lb', [10; 10], 'ub', [12; 12]);
Punbounded = Polyhedron('lb', [10; 10]);
B = Polyhedron.unitBox(2)*1e4;
R = Polyhedron.fullSpace(2);


assert(R.contains(E));
assert(R.contains(Pbounded));
assert(R.contains(Punbounded));
assert(R.contains(B));
assert(R.contains(R));

% but no bounded set can contain R^n
assert(~E.contains(R));
assert(~Pbounded.contains(R));
assert(~Punbounded.contains(R));
assert(~B.contains(R));

end
