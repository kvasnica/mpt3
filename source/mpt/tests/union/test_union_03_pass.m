function test_union_03_pass
%
% polyhedron
%

P = ExamplePoly.randHrep;

U = Union(P);

if U.Num~=1
    error('Must have 1 element.');
end


end