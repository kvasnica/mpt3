function test_polyhedron_minus_05_pass
%
% array of (H,He)-He polyhedra
%

P(1) = ExamplePoly.randHrep('d',2);
P(2) = ExamplePoly.randHrep('d',2,'ne',1);
S = 0.01*ExamplePoly.randHrep('d',2,'ne',2);


R = P-S;

for i=1:2
    if ~P.contains(R(i))
        error('P must contain both R.');
    end
end
end