function test_polyhedron_isadjacent_06_pass
%
%  test does not apply for polyhedra in different dimension
%

P = ExamplePoly.randHrep;  % 2D
Q = Polyhedron(randn(5,3)); % 3D

% must be adjacent because He is a facet of P
[worked, msg] = run_in_caller('P.isAdjacent(Q); ');
assert(~worked);
asserterrmsg(msg,'Polyhedra must be in the same dimension.');

end