function test_polyunion_add_11_pass
%
% same function names
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randHrep;
P.addFunction(AffFunction(randn(1,2)),'a');
P.addFunction(AffFunction(randn(1,2)),'b');

PU = PolyUnion(P);

Q = ExamplePoly.randHrep('ne',1);
Q.addFunction(AffFunction(randn(1,2)),'a');
Q.addFunction(AffFunction(randn(1,2)),'b');

% Q must have the same function names as P
PU.add(Q);


end