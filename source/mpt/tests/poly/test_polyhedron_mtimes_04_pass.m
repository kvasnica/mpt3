function test_polyhedron_mtimes_04_pass
%
% V-H polyhedra in different dimension
%

P = ExamplePoly.randVrep('d',5);
Q = Polyhedron('H',randn(2,8));

R = P*Q;

if R.isEmptySet
    error('R is not empty.');
end
if R.Dim~=12
    error('Wrong dimension of the new set.');
end

end
