function test_polyhedron_slice_03_fail
%
% higher dim than polyhedron
% 

P = ExamplePoly.randHrep('d',3);

P.slice([1; 5],[0.2 0.5]);

end