function test_polyhedron_isbounded_18_pass
% issue #133: isbounded gives wrong answer when the polytope is too big

% this has always worked
assert(isBounded(Polyhedron('lb', -1e4+1, 'ub', 1e4-1)));
assert(isBounded(Polyhedron('lb', -1e4+1, 'ub', 1e4)));
assert(isBounded(Polyhedron('lb', -1e4, 'ub', 1e4-1)));

% these are affected by issue #133:
assert(isBounded(Polyhedron([1; -1], [1e4; 1e4])));
assert(isBounded(Polyhedron('lb', -1e4, 'ub', 1e4)));
assert(isBounded(Polyhedron('lb', -1e4-1, 'ub', 1e4)));
assert(isBounded(Polyhedron('lb', -1e4, 'ub', 1e4+1)));
assert(isBounded(Polyhedron('lb', -1e5, 'ub', 1e5)));
assert(isBounded(Polyhedron('lb', -1e4-1, 'ub', 1e4+1)));
assert(isBounded(Polyhedron('lb', -1e7, 'ub', 1e7)));

end