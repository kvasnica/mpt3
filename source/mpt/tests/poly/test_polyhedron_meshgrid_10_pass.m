function test_polyhedron_meshgrid_10_pass
%
% 1D polyhedron
%

P=Polyhedron('lb',0,'ub',1);

[worked, msg] = run_in_caller('P.meshGrid; ');
assert(~worked);
asserterrmsg(msg,'The mesh grid can be computed only for 2D polytopes.');

end