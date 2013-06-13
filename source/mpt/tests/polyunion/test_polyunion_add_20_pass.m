function test_polyunion_add_20_pass
%
% different function test_polyunion_add_20_pass
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randHrep;
[worked, msg] = run_in_caller('P.addFunction(AffFunction(randn(1,2))); ');
assert(~worked);
asserterrmsg(msg,'Not enough input arguments.');

PU = PolyUnion(P);

Q = ExamplePoly.randHrep('ne',1);

% Q must have function handle
PU.add(Q);


end