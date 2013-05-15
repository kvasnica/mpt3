function test_polyunion_add_03_fail
%
% two connected & bounded polyhedra, add unbounded one
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randVrep;

while any(~P.isBounded)
    P(1)=ExamplePoly.randHrep;
    P(2)=ExamplePoly.randVrep;
end

PU = PolyUnion('Set',P,'Connected',true,'Bounded',true);

Q(1) = ExamplePoly.randHrep;
Q(2) = Polyhedron('He',rand(1,3));

% if Q is added, the convexity remains
PU.add(Q);


end