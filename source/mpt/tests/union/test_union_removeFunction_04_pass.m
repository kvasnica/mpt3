function test_union_removeFunction_04_pass
%
% union, three functions
%

for i=1:5
    P(i) = ExamplePoly.randHrep('d',4);
    P(i).addFunction(AffFunction(randn(1,4)), 'a');
    P(i).addFunction(AffFunction(randn(1,4)),'b');
    P(i).addFunction(AffFunction(randn(1,4)),'omega');
end

U = Union(P);

U.removeFunction({'b','omega'});

s = U.listFunctions;
assert(isequal(s, {'a'}));

end
