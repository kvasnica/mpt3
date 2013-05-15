function test_polyunion_getfunction_04_pass
%
% random polyhedra, two functions, one string, no string
%

for i=1:5
    P(i) = ExamplePoly.randVrep('d',4);
    P(i).addFunction(AffFunction(randn(1,4),0), 'a');
    P(i).addFunction(AffFunction(randn(1,4),1),'nogaz');
end
    
U = PolyUnion('Set',P,'Overlaps',true);

Un1 = U.getFunction('nogaz');

assert(isequal(Un1.listFunctions, {'nogaz'}));
Un1.convexHull;

if isfield(U.Internal,'convexHull')
    error('The field must not be here because Un is a new copy.');
end
if ~Un1.Internal.Overlaps
    error('The "Overlaps" property must be the same.');
end

end
