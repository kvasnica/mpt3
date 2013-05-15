function test_polyunion_removeFunction_01_fail
%
% two functions, index out of the range
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)));
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
end
U = PolyUnion(P);

U.removeFunction(1:3);

end