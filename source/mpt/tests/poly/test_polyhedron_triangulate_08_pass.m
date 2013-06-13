function test_polyhedron_triangulate_08_pass
%
% infeasible polyhedron
%

P = Polyhedron('H',randn(24,4));

[worked, msg] = run_in_caller('T = triangulate(P); ');
assert(~worked);
asserterrmsg(msg,'Only bounded, non-empty polyhedra in the full dimension can be triangulated.');


end