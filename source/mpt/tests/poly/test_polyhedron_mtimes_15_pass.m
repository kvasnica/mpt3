function test_polyhedron_mtimes_15_pass
%
% wrong type of scalar
%

P = ExamplePoly.randHrep('d',3,'ne',1);

[worked, msg] = run_in_caller('R = Inf*P; ');
assert(~worked);
asserterrmsg(msg,'Input argument must be a real vector.');

end
