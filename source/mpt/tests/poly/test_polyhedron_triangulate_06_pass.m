function test_polyhedron_triangulate_06_pass
%
% empty polyhedron
%

P = Polyhedron;

[worked, msg] = run_in_caller('T = triangulate(P); ');
assert(~worked);
asserterrmsg(msg,'Only bounded, non-empty polyhedra in the full dimension can be triangulated.');


end