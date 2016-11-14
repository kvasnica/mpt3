function test_polyunion_copy_06_pass
%
% unions, properties specified, add to union
%

P = ExamplePoly.randVrep('d',3);
T = P.triangulate;

U = PolyUnion('Set',T(1:end-1),'Overlaps',false,'FullDim',true,'Bounded',true);

Un = U.copy;

U.convexHull;
U.add(T(end));

if Un.Num==U.Num
    error('The number of sets differ.');
end

if isfield(Un.Internal,'convexHull')
    error('The field "convexHull" must not be here because it is a new copy.');
end

if Un.Internal.Overlaps~=U.Internal.Overlaps || ...
        Un.Internal.FullDim~=U.Internal.FullDim || ...
            Un.Internal.Bounded~=U.Internal.Bounded
    error('Internal properties must hold.')
end





end