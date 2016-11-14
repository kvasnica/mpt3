function test_polyhedron_triangulate_09_pass
%
% low-dim polyhedron
%

P = 10*ExamplePoly.randHrep('d',7,'ne',2);

[worked, msg] = run_in_caller('T = triangulate(P); ');
assert(~worked);
asserterrmsg(msg,'Only bounded, non-empty polyhedra in the full dimension can be triangulated.');


end