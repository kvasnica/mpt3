function test_polyhedron_minus_11_pass
%
% 2D fulldim-Vrep - vector
%

P = ExamplePoly.randVrep;
while ~P.contains([0;0]);
    P = ExamplePoly.randVrep;
end
x = 5*randn(2,1);

R = P-x;

if ~R.contains(-x)
    error('R must contain -x.');
end
end