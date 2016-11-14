function test_union_remove_02_pass
%
% remove polyhedron/yset at once
%

U = Union(ExamplePoly.randHrep);

% add Yset
x = sdpvar(4,1);
F = (x>=0);
Y = YSet(x,F);
U.add([Y,Y]);

% remove both YSETS
U.remove([2,3]);

if U.Num~=1
    error('Must remain only polyhedron here.');
end

end
