function test_polyunion_removeFunction_02_fail
%
% two functions, wrong name
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)));
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
end
U = PolyUnion(P);

U.removeFunction(1);

U.removeFunction('B');
end