function test_convexset_support_07_pass
%
% array of random polyhedra in 3D
%

P(1) = Polyhedron(randn(15,3));
P(2) = Polyhedron('lb',-randn(3,1),'He',rand(1,4),'A',[1 -0.4 0],'b',1.5);

v = 5*randn(3,1);

s = P.support(v);

end