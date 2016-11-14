function test_polyhedron_intersect_02_pass
%
% H-V polyhedra
%

P = Polyhedron('lb',[0;0;0]);
S = ExamplePoly.randVrep('d',3);

R = P.intersect(S);

if isEmptySet(R)
    error('Must not be empty.');
end


end