function test_polyhedron_intersect_01_pass
%
% H-H polyhedra
%

P = Polyhedron('lb',[0;0;0]);
S = ExamplePoly.randHrep('d',3);

R = P.intersect(S);

if isEmptySet(R)
    error('Must not be empty.');
end


end