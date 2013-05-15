function test_polyhedron_plus_06_pass
%
% array of V-V polyhedra
%

P(1) = ExamplePoly.randVrep('d',3);
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