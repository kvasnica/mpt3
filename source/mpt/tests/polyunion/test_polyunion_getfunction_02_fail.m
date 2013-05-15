function test_polyunion_getfunction_02_fail
%
% random polyhedra, no matching string
%

for i=1:5
    P(i) = ExamplePoly.randVrep('d',6);
    P(i).addFunction(AffFunction(randn(2,6),[1;2]),'function1');
    P(i).addFunction(AffFunction(randn(2,6),[-1;-2]),'function2');
end
    
U = PolyUnion('Set',P,'Overlaps',true);

Un = U.getFunction('func');

end