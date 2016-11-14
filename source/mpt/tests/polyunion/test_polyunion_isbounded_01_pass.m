function test_polyunion_isbounded_01_pass
%
% union of bounded sets
%

P(1) = ExamplePoly.randVrep;
P(2) = ExamplePoly.randVrep;
P(3) = ExamplePoly.randVrep;


PU = PolyUnion(P);

if ~PU.isBounded
    error('This union must be bounded.');
end


end