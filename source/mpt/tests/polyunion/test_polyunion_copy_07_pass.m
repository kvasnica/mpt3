function test_polyunion_copy_07_pass
%
% functions over unions
%

P = ExamplePoly.randVrep('d',3);
T = P.triangulate;
T.addFunction(AffFunction([1,2,3]),'a');

U = PolyUnion('Set',T,'Convex',true,'Overlaps',false,'FullDim',true,'Bounded',true);

Un = U.copy;

U.convexHull;

if Un.Num~=U.Num
    error('The number of sets are the same.');
end

if isfield(Un.Internal,'convexHull')
    error('The field "convexHull" must not be here because it is a new copy.');
end

if Un.Internal.Overlaps~=U.Internal.Overlaps || ...
        Un.Internal.FullDim~=U.Internal.FullDim || ...
        Un.Internal.Bounded~=U.Internal.Bounded || ...
        Un.Internal.Convex~=U.Internal.Convex
    error('Internal properties must hold.')
end

if isempty(Un.listFunctions)
    error('The function handles must be copied as well.');
end




end