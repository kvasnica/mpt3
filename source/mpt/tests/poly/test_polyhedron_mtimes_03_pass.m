function test_polyhedron_mtimes_03_pass
%
% He-H polyhedra in different dimension
%

P = ExamplePoly.randHrep('d',3,'ne',1);
Q = ExamplePoly.randHrep('d',4);

R = P*Q;

if R.isEmptySet
    error('R is not empty.');
end
if R.Dim~=7
    error('Wrong dimension of the new set.');
end

end
