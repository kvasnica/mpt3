function test_polyunion_removeFunction_01_pass
%
% two functions
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
    P(i).addFunction(AffFunction(randn(1,2),rand(1)), 'a');
    P(i).addFunction(AffFunction(randn(1,2),rand(1)),'b');
end
U = PolyUnion(P);

U.removeFunction('b');

s = U.listFunctions;
if numel(s)>1
    error('Wrong number of functions.');
end

U.removeFunction('a');

sn = U.listFunctions;
if numel(sn)~=0
    error('No functions here.');
end

end
