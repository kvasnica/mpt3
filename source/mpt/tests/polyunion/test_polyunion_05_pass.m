function test_polyunion_05_pass
%
% polyhedra, non-overlapping, convex
%

P(1) = Polyhedron('ub',0);
P(2) = Polyhedron('lb',0);
U = PolyUnion('Set',P,'convex',true,'overlaps',false);

if U.Num~=2
    error('Must have 2 elements.');
end
if ~U.Internal.Convex
    error('Must be convex because it is only one set.');
end

if U.Internal.Overlaps
    error('Must be non-overlapping because it is only one set.');
end


end