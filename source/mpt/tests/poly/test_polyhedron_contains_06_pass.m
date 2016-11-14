function test_polyhedron_contains_06_pass
%
% V-V in 4D 
%

P = ExamplePoly.randVrep('d',4);
while ~P.contains([0;0;0;0])
    P = ExamplePoly.randVrep('d',4);
end
S = P*1.001;

if ~S.contains(P)
    error('S must contain P.')
end

end