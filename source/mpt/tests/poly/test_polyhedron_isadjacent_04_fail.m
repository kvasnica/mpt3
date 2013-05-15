function test_polyhedron_isadjacent_04_fail
%
%  test does not apply for polyhedra in different dimension
%

P = ExamplePoly.randHrep;  % 2D
Q = Polyhedron(randn(5,3)); % 3D

% must be adjacent because He is a facet of P
P.isAdjacent(Q);

end