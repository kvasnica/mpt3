function test_polyhedron_plus_07_pass
%
% array of [R,V]-V polyhedra
%

P(1) = Polyhedron('R',[0 1 -1;0.1 -0.2 1]);
P(2) = ExamplePoly.randVrep('d',3);
S = ExamplePoly.randVrep('d',3);


R = P+S;

if ~R.contains(S)
    error('R must contain S polyhedra.');
end
for i=1:2
    if ~R.contains(P(i))
        error('R must contain both P.');
    end
end
end