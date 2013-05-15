function test_union_add_05_pass
%
% add full polyhedron/yset to empty/nonempty union array
%

U = Union(ExamplePoly.randHrep);

% add empty polyhedron
U.add(Polyhedron);

if U.Num~=1
    error('Cannot add empty polyhedra.');
end


x = sdpvar(1);
F = set(-1<=x<=-2);
U.add(YSet(x,F));

if U(1).Num~=1
    error('Must not be empty.');
end


end
