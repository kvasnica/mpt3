function test_polyunion_add_04_fail
%
% bounded polyhedron + unbounded polyhedron
%

P=ExamplePoly.randVrep;

PU = PolyUnion('Set',P,'Bounded',true);

Q(1) = ExamplePoly.randHrep;
Q(2) = Polyhedron('He',rand(1,3));

% if Q is added, the convexity remains
PU.add(Q);


end