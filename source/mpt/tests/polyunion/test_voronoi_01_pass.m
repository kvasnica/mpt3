function test_voronoi_01_pass
% reject bogus cases

[~, msg] = run_in_caller('V = mpt_voronoi([]);');
asserterrmsg(msg, 'First input must be a non-empty set of points.');

[~, msg] = run_in_caller('V = mpt_voronoi(Polyhedron);');
asserterrmsg(msg, 'First input must be a non-empty set of points.');

[~, msg] = run_in_caller('V = mpt_voronoi(1);');
asserterrmsg(msg, 'More than one point please.');

% unrecognized option
[~, msg] = run_in_caller('V = mpt_voronoi([1 2], ''bogus'', 1);');
asserterrmsg(msg, 'Argument ''bogus'' did not match any valid parameter of the parser.');

% wrong option
[~, msg] = run_in_caller('V = mpt_voronoi([1 2], ''bound'', 1);');
asserterrmsg(msg, 'Input argument must be a "Polyhedron" class.');

% wrong dimension
[~, msg] = run_in_caller('V = mpt_voronoi([1 2], ''bound'', Polyhedron);');
asserterrmsg(msg, 'The bound must be a polyhedron in R^1.');

% empty bound
P = Polyhedron([1; -1], [-1; 0]);
assert(P.isEmptySet);
[~, msg] = run_in_caller('V = mpt_voronoi([1 2], ''bound'', P);');
asserterrmsg(msg, 'The bound must not be an empty set.');

end
