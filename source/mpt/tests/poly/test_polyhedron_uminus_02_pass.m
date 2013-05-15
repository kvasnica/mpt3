function test_polyhedron_uminus_02_pass
%
% V-rep, 5D
%

P = 10*ExamplePoly.randHrep('d',5);

T = -P;

R = -T;

if R~=P
    error('Polyhedra must be the same.');
end

end