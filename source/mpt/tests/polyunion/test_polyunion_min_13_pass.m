function test_polyunion_min_13_pass
% non-scalar functions must be rejected

P = Polyhedron('lb', -1, 'ub', 1);
P.addFunction(AffFunction([1; 1], [0; 2]), 'f');
[~, msg] = run_in_caller('M = PolyUnion(P).min()');
asserterrmsg(msg, 'Only scalar-valued functions can be handled.');

end
