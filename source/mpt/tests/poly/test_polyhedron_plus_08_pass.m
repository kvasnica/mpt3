function test_polyhedron_plus_08_pass
%
% array of [R,V]-H polyhedra
%

P(1) = Polyhedron('V',randn(8,5),'R',rand(2,5));
P(2) = ExamplePoly.randVrep('d',5);

% must contain origin
while ~any(P.contains(zeros(5,1)))
    P(1) = Polyhedron('V',randn(8,5),'R',rand(2,5));
    P(2) = ExamplePoly.randVrep('d',5);
end

S = Polyhedron('lb',-0.1*ones(5,1),'ub',0.1*ones(5,1));

R = P+S;

% in V-rep the set containment test shows problems when comparing in higher
% dimensions. If it fails for S, the it typically passes on 0.99*S
if ~R.contains(S)
    error('R must contain S polyhedra.');
end
for i=1:2
    if ~R.contains(P(i))
        error('R must contain both P.');
    end
end
end