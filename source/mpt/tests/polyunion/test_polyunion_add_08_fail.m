function test_polyunion_add_08_fail
%
% different function handles
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randHrep;
P.addFunction(AffFunction(randn(1,2)));

PU = PolyUnion(P);

Q = ExamplePoly.randHrep('ne',1);

% Q must have function handle
PU.add(Q);


end