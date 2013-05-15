function test_polyunion_add_05_fail
%
% unly full-dim
%

P(1)=ExamplePoly.randVrep;
P(2)=ExamplePoly.randVrep;

PU = PolyUnion('Set',P,'Bounded',true,'FullDim',true);

Q(1) = ExamplePoly.randHrep;
Q(2) = Polyhedron('He',rand(1,3),'lb',zeros(1,2));

% if Q is added, the convexity remains
PU.add(Q);


end