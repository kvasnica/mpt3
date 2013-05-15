function test_union_add_04_pass
%
% add full polyhedron/yset to empty/nonempty union array
%

U = [Union; Union(ExamplePoly.randHrep)];

U.add(ExamplePoly.randHrep);

if U(1).Num~=1
    error('Must not be empty.');
end
if U(2).Num~=2
    error('Must not be empty.');
end

x = sdpvar(1);
F = set(x>=0);
U.add(YSet(x,F));

if U(1).Num~=2
    error('Must not be empty.');
end
if U(2).Num~=3
    error('Must not be empty.');
end


end
