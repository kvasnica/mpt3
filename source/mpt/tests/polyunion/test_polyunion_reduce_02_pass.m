function test_polyunion_reduce_02_pass
%
% one polyhedron
%

U = PolyUnion(ExamplePoly.randHrep('d',5));
U.reduce;
if U.Num~=1
    error('Must be one element.');
end

end