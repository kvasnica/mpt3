function test_polyhedron_plus_12_pass
%
% 2D fulldim-Vrep + vector
%

P = ExamplePoly.randVrep;
x = 0*randn(2,1);

R = P+x;

if R~=P
    error('R is the same as P.');
end
end