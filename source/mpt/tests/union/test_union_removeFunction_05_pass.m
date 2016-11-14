function test_union_removeFunction_05_pass
%
% arrays of union
%

for i=1:5
    P(i) = ExamplePoly.randHrep('d',4);
    P(i).addFunction(AffFunction(randn(1,4)), 'a');
    P(i).addFunction(AffFunction(randn(1,4)),'b');
    P(i).addFunction(AffFunction(randn(1,4)),'omega');
    Q(i) = ExamplePoly.randHrep('d',4);
    Q(i).addFunction(AffFunction(randn(1,4)), 'a');
    Q(i).addFunction(AffFunction(randn(1,4)),'b');
    Q(i).addFunction(AffFunction(randn(1,4)),'omega');
end

U(1) = Union(P);
U(2) = Union(Q);

U.removeFunction({'b','omega'});

for i=1:2
	assert(isequal(U(i).listFunctions, {'a'}));
end
end
