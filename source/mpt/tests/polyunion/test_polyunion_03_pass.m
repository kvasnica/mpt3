function test_polyunion_03_pass
%
% polyhedron
%

P = ExamplePoly.randHrep;

U = PolyUnion(P);

if U.Num~=1
    error('Must have 1 element.');
end

if ~U.Internal.Convex
    error('Must be convex because it is only one set.');
end

if U.Internal.Overlaps
    error('Must be non-overlapping because it is only one set.');
end

if ~U.Internal.Connected
    error('Must be connected because it is only one set.');
end


end