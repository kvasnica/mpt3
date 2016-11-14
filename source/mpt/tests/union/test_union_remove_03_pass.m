function test_union_remove_03_pass
%
% remove polyhedron/yset at once from array
%

U(1) = Union;
U(2) = Union(ExamplePoly.randHrep);

% add Yset
x = sdpvar(2,1);
F = (0<=x<=1);
Y = YSet(x,F);
U.add([Y,Y]);

% remove  YSET from array
U.remove(2);

if U(1).Num~=1
    error('Must be empty');    
end
if U(2).Num~=2
    error('Must remain only polyhedron here.');
end

end
