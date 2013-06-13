function test_polyhedron_meshgrid_07_pass
%
% empty polyhedron
%

P=Polyhedron;

[worked, msg] = run_in_caller('P.meshGrid; ');
assert(~worked);
asserterrmsg(msg,'Can only grid nonempty and bounded polyhedra.');

end