function test_union_removeFunction_03_pass
%
% union, one function
%

for i=1:5
    P(i) = ExamplePoly.randHrep('d',4);
    P(i).addFunction(AffFunction(randn(1,4)), 'f');
end

U = Union(P);

U.removeFunction('f');

s = U.listFunctions;

if ~isempty(s)
    error('There are no functions here.');
end
end
