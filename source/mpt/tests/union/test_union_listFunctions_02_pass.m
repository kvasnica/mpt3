function test_union_listFunctions_02_pass
%
% arrays of unions
%


for i=1:5
    P(i) = ExamplePoly.randHrep;
end
P.addFunction(Function(@(x)x),'x');

U(1) = PolyUnion(P);
U(2) = PolyUnion(P([1,4]));

for i = 1:length(U)
	assert(isequal(U(i).listFunctions, {'x'}));
end

end
