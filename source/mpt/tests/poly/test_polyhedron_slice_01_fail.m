function test_polyhedron_slice_01_fail
%
% empty polyhedron
% 

P = Polyhedron;

P.slice(1,[0.2 0.5]);

end