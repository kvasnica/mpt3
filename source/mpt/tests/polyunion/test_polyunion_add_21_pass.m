function test_polyunion_add_21_pass
%
% different function test_polyunion_add_21_pass
%

P(1)=ExamplePoly.randHrep;
P(2)=ExamplePoly.randHrep;
P.addFunction(AffFunction(randn(1,2)),'a');
P.addFunction(AffFunction(randn(1,2)),'b');

PU = PolyUnion(P);

Q = ExamplePoly.randHrep('ne',1);
[worked, msg] = run_in_caller('Q.addFunction(AffFunction(randn(1,2))); ');
assert(~worked);
asserterrmsg(msg,'Not enough input arguments.');
Q.addFunction(AffFunction(randn(1,2)),'b');

% Q must have the same function names as P
[worked, msg] = run_in_caller('PU.add(Q); ');
assert(~worked);
asserterrmsg(msg,'The set 1 to be added holds different function names than the union.');


end