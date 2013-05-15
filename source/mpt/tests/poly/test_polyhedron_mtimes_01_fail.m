function test_polyhedron_mtimes_01_fail
%
% polyhedron-matrix
%

P = ExamplePoly.randHrep('d',3,'ne',2);
A = [randn(2,3); 0 0 0];

R = P*A;

end
