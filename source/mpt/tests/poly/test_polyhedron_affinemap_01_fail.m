function test_polyhedron_affinemap_01_fail
%
% wrong dimension
%

P = Polyhedron('H',randn(5));

Q = P.affineMap(randn(3));

end