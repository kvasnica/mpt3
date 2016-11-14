function test_union_add_02_pass
%
% add full polyhedron to empty/nonempty union
%

U = Union;

U.add(ExamplePoly.randHrep);

if U.Num~=1
    error('Must not be empty.');
end

U.add(ExamplePoly.randHrep);

if U.Num~=2
    error('Must not be empty.');
end


end