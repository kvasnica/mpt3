function test_polyhedron_plus_09_pass
%
% 2D fulldim + empty polyhedron
%

P = ExamplePoly.randHrep;
S = Polyhedron;

R = P+S;

if R~=P
    error('R is the same as P.');
end
end