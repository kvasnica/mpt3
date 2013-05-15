function test_polyunion_getfunction_01_fail
%
% random polyhedra, no functions
%

for i=1:5
    P(i) = ExamplePoly.randVrep('d',6);
end
    
U = PolyUnion('Set',P,'Overlaps',true,'Bounded',true);

Un = U.getFunction(1);

end