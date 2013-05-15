function test_polyhedron_slice_02_fail
%
% wrong dim
% 

P = ExamplePoly.randHrep('d',3);

P.slice([1; 0.5],[0.2 0.5]);

end