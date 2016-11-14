function test_polyhedron_plus_11_pass
%
% 2D fulldim-Vrep + vector
%

P = ExamplePoly.randVrep;
x = 5*randn(2,1);

R = P+x;

if ~R.contains(x)
    error('R must contain x.');
end
end