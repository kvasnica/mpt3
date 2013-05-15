function test_polyunion_getfunction_03_pass
%
% random polyhedra, two functions, exact strings
%

for i=1:5
    P(i) = ExamplePoly.randHrep('d',5);
    P(i).addFunction(AffFunction(randn(4,5),randn(4,1)),'height');
    P(i).addFunction(AffFunction(randn(4,5),randn(4,1)),'weight');
end
    
U = PolyUnion(P);

Un = U.getFunction('weight');
assert(isequal(Un.listFunctions, {'weight'}));

% the original union should stay unmodified
assert(isequal(U.listFunctions, {'height', 'weight'}));

end
