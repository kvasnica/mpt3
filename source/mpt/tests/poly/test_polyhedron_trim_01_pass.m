function test_polyhedron_trim_01_pass
% tests ConvexSet/trimFunction

% only affine functions can be trimmed
P = Polyhedron('lb', -1, 'ub', 1);
q = QuadFunction(1);
h = @(x) x;
P.addFunction(q, 'q');
P.addFunction(h, 'h');

[~, msg] = run_in_caller('P.trimFunction(''bogus'', 1);');
asserterrmsg(msg, 'No such function "bogus" in the object.');

[~, msg] = run_in_caller('P.trimFunction(''q'', 1);');
asserterrmsg(msg, 'Only affine functions can be trimmed.');

[~, msg] = run_in_caller('P.trimFunction(''h'', 1);');
asserterrmsg(msg, 'Only affine functions can be trimmed.');

end
