function test_polyhedron_projection_14_pass
%
% wrong dim
%

P = ExamplePoly.randHrep('d',7);

[worked, msg] = run_in_caller('R=P.projection([4;15]); ');
assert(~worked);
asserterrmsg(msg,'Cannot compute projection on higher dimension than 7.');

end