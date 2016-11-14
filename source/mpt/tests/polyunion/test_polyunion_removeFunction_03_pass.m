function test_polyunion_removeFunction_03_pass
%
% two functions, wrong name
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'a');
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
end
U = PolyUnion(P);

[worked, msg] = run_in_caller('U.removeFunction(''B''); ');
assert(~worked);
asserterrmsg(msg,'No such function "B" in the object.');
end