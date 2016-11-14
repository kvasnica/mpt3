function test_polyhedron_mtimes_02_pass
%
% H-H polyhedra
%

P = ExamplePoly.randHrep;
Q = ExamplePoly.randHrep;

R = P*Q;

if R.isEmptySet
    error('R is not empty.');
end

end
