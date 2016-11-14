function test_polyhedron_projection_13_pass
%
% wrong dim
%

P = ExamplePoly.randHrep;

[worked, msg] = run_in_caller('R=P.projection([0.1;2]); ');
assert(~worked);
asserterrmsg(msg,'Input argument is a not valid dimension.');

end