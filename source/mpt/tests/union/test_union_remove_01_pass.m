function test_union_remove_01_pass
%
% remove polyhedron
%

U = Union(ExamplePoly.randHrep);

% remove polyhedron
U.remove(1);

if U.Num~=0
    error('Must be empty');
end

end