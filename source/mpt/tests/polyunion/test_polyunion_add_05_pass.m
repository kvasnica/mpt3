function test_polyunion_add_05_pass
%
% two connected polyhedra, the third is connected as vell
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randVrep;

PU = PolyUnion('Set',P,'Connected',true);

Q=ExamplePoly.randHrep;

% if Q is added, the convexity remains
PU.add(Q);


end