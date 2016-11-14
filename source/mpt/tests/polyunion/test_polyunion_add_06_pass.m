function test_polyunion_add_06_pass
%
% two connected polyhedra, the two others as vell
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randVrep;

PU = PolyUnion('Set',P,'Connected',true);

Q(1) = ExamplePoly.randHrep;
Q(2) = ExamplePoly.randHrep;

% if Q is added, the convexity remains
PU.add(Q);


end