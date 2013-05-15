function test_polyhedron_mtimes_05_fail
%
% wrong type of scalar
%

P = ExamplePoly.randHrep('d',3,'ne',1);

R = P*Inf;

end
