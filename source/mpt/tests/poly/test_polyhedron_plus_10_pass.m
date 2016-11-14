function test_polyhedron_plus_10_pass
%
% 2D fulldim + vector
%

P = ExamplePoly.randHrep;
x = 5*randn(2,1);

R = P+x;

if ~R.contains(x)
    error('R must contain x.');
end
end