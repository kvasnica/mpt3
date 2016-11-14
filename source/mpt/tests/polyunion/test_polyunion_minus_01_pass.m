function test_polyunion_minus_01_pass
%
% empty polyhedron
%

for i=1:5
   P(i) = ExamplePoly.randVrep;     
end

U = PolyUnion(P);

% check few properties first
U.isOverlapping;
U.isConvex;
U.isBounded;

Un = U-Polyhedron;

if Un.Num~=5
    error('The object should not change because Q isempty.');
end

end