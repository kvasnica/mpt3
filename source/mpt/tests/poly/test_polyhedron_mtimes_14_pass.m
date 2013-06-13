function test_polyhedron_mtimes_14_pass
%
% wrong type of scalar
%

P = ExamplePoly.randHrep('d',3,'ne',1);

[worked, msg] = run_in_caller('R = true*P; ');
assert(~worked);
asserterrmsg(msg,'This type of the object "logical" is not supported as argument for "P".');

end
