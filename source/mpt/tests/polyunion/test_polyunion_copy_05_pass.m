function test_polyunion_copy_05_pass
%
% arrays of unions, properties specified 
%

P(1) = ExamplePoly.randHrep;
P(2) = ExamplePoly.randVrep;
P.addFunction(Function(@(x)x),'a');
P.addFunction(Function(@(x)x.^2),'b');
Q(1) = ExamplePoly.randZono;
Q(2) = Q(1).outerApprox;

U(1) = PolyUnion(P);
U(2) = PolyUnion('Set',Q,'FullDim',true,'Convex',true,'Overlaps',true);
Un = U.copy;

% compute convexHull
U.convexHull;

for i=1:2
    % Un must not have bounding box values present
    if isfield(Un(i).Internal,'convexHull')
        error('The field "convexHull" must not be here because it is a new copy.')
    end    
end
if Un(2).Internal.Convex~=U(2).Internal.Convex
    error('The internal property must remain the same.');
end
if Un(2).Internal.Overlaps~=U(2).Internal.Overlaps
    error('The internal property must remain the same.');
end


end