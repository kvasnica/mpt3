function test_union_add_03_pass
%
% add full polyhedron/yset to empty/nonempty union
%

U = Union;

U.add(ExamplePoly.randHrep);

if U.Num~=1
    error('Must not be empty.');
end

x = sdpvar(1);
F = (x>=0);
U.add(YSet(x,F));

if U.Num~=2
    error('Must not be empty.');
end


end
