function test_polyunion_convexhull_01_pass
%
% empty polyunion
%

U = PolyUnion;
H = U.convexHull;


if ~isEmptySet(H)
    error('H is empty.');
end

end