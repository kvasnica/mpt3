function test_convexset_vertcat_02_pass
%
% 2 same objects
%

P = Polyhedron(randn(5));
Q = Polyhedron(randn(3));

Y = [P;Q];


end