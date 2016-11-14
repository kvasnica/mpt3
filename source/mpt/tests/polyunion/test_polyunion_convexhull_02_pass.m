function test_polyunion_convexhull_02_pass
%
% one set
%

U = PolyUnion(ExamplePoly.randHrep);
H = U.convexHull;


if numel(H)~=1
    error('Only one polyhedron H is here.');
end

end