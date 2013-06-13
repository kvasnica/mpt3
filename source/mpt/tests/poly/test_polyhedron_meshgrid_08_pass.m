function test_polyhedron_meshgrid_08_pass
%
% unbounded polyhedron
%

P=Polyhedron('lb',[0;0;0]);

[worked, msg] = run_in_caller('P.meshGrid; ');
assert(~worked);
asserterrmsg(msg,'Can only grid nonempty and bounded polyhedra.');

end