function test_polyhedron_homogenize_01_fail
%
% wrong type
%

P = ExamplePoly.randVrep;

R = P.homogenize('hrepp');

end