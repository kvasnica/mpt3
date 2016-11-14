function test_polyhedron_uminus_06_pass
%
% ray
%

P = Polyhedron('R',randn(1,3));

T = -P;
Q = -T;
if Q~=P;
    error('Polyhedra must be the same.');
end

end