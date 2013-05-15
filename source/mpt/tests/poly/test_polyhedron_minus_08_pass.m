function test_polyhedron_minus_08_pass
%
% array of [R,V]-H polyhedra
%

P(1) = Polyhedron('V',randn(8,5),'R',rand(2,5));
P(2) = ExamplePoly.randVrep('d',5);
while ~P(2).contains([0;0;0;0;0])
    P(2) = ExamplePoly.randVrep('d',5);
end
S = Polyhedron('lb',-0.1*ones(5,1),'ub',0.1*ones(5,1));

R = P-S;

for i=1:2
    if ~P.contains(R(i))
        error('P must contain both R.');
    end
end
end