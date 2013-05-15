function test_union_removeFunction_02_pass
%
% union, no function
%

for i=1:5
    P(i) = ExamplePoly.randHrep('d',4);
end

U = Union(P);

U.removeFunction([]);

s = U.listFunctions;

if ~isempty(s)
    error('There are no functions here.');
end
end