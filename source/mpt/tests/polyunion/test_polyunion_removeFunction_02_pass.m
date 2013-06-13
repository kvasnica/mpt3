function test_polyunion_removeFunction_02_pass
%
% two functions, index out of the range
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'a');
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
end
U = PolyUnion(P);

[worked, msg] = run_in_caller('U.removeFunction(1:3); ');
assert(~worked);
asserterrmsg(msg,'No such function');

end