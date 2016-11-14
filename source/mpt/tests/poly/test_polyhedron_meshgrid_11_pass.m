function test_polyhedron_meshgrid_11_pass
%
% 3D polyhedron
%

P=ExamplePoly.randHrep('d',3);

[worked, msg] = run_in_caller('P.meshGrid; ');
assert(~worked);
asserterrmsg(msg,'The mesh grid can be computed only for 2D polytopes.');

end