function test_polyhedron_projection_15_pass
%
% wrong dim
%

P = ExamplePoly.randHrep('d',7);

[worked, msg] = run_in_caller('R=P.projection([4;1;0;5]); ');
assert(~worked);
asserterrmsg(msg,'Input argument is a not valid dimension.');

end