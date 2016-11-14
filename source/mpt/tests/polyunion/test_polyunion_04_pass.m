function test_polyunion_04_pass
%
% polyhedron array
%

P = [ExamplePoly.randHrep; ExamplePoly.randVrep];

U = PolyUnion(P);

if U.Num~=2
    error('Must have 2 elements.');
end


end