function test_polyhedron_contains_32_pass

% empty set is contained any any non-empty set
E = Polyhedron.emptySet(2);
P = Polyhedron('lb', [10; 10], 'ub', [12; 12]);
assert(P.contains(E));

% each set contains the empty set
assert(E.contains(E));
assert(P.contains(E));

end
