function test_polyhedron_contains_17_pass
%
% ge, gt
%

P = ExamplePoly.randVrep('d',3,'nr',2);

R = Polyhedron('V',P.V*1.00001,'R',P.R);

if ~(R>P)
    error('R must be contained in P.');
end

if ~(R>=P)
    error('R must be contained in P.');
end


end