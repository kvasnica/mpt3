function test_union_listFunctions_03_pass
%
% arrays of name, no name
%

for i=1:5
    P(i) = ExamplePoly.randHrep;
end
P.addFunction(Function(@(x)x), 'y');
P.addFunction(Function(@(x)x.^2),'x');
U = PolyUnion(P);

assert(isequal(U.listFunctions, {'x', 'y'})); % sorted by containers.Map

end
