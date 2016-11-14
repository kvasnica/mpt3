function test_polyhedron_triangulate_07_pass
%
% not bounded polyhedron
%

P = Polyhedron('V',randn(5),'R',[0 0 1 -2 0.5]);

[worked, msg] = run_in_caller('T = triangulate(P); ');
assert(~worked);
asserterrmsg(msg,'Only bounded, non-empty polyhedra in the full dimension can be triangulated.');


end