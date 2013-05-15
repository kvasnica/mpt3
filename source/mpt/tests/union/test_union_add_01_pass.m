function test_union_add_01_pass
%
% add empty polyhedron to empty union
%

U = Union;

U.add(Polyhedron);

if U.Num~=0
    error('Must be empty.');
end

end