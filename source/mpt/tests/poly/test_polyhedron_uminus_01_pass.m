function test_polyhedron_uminus_01_pass
%
% H-rep, 3D
%

P = 10*ExamplePoly.randHrep('d',3);

T = -P;

R = -T;

if R~=P
    error('Polyhedra must be the same.');
end

end