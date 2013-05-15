function test_polyhedron_contains_25_pass
% containement of empty sets

P = Polyhedron;
Q = Polyhedron('lb', -1, 'ub', 1);
R = Polyhedron([1; -1], [0; -1]);

% empty set is always contained in a non-empty set
status = P<=Q;
assert(status);

% non-empty set cannot be contained in an empty set
status = Q<=P;
assert(~status);

% empty set is always contained in an empty set
status = P<=R;
assert(status);

end
