function test_polyhedron_mtimes_12_pass
%
% polyhedron-matrix
%

P = ExamplePoly.randHrep('d',3,'ne',2);
A = [randn(2,3); 0 0 0];

[worked, msg] = run_in_caller('R = P*A; ');
assert(~worked);
asserterrmsg(msg,'Multiplication from the right by a matrix is not well-defined for a polyhedron.');

end
