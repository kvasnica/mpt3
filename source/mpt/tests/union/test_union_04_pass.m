function test_union_04_pass
%
% polyhedron array
%

P = [ExamplePoly.randHrep; ExamplePoly.randVrep('d',8)];

U = Union(P);

if U.Num~=2
    error('Must have 2 elements.');
end


end