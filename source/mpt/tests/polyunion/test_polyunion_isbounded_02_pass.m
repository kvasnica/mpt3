function test_polyunion_isbounded_02_pass
%
% union array, bounded sets
%

P(1) = ExamplePoly.randVrep('d',5);
P(2) = ExamplePoly.randVrep('d',5);
Q(1) = ExamplePoly.randVrep('d',3);
Q(2) = ExamplePoly.randVrep('d',3);


PU(1) = PolyUnion(P);
PU(2) = PolyUnion(Q);

if ~any(PU.isBounded)
    error('This unions must be bounded.');
end


end