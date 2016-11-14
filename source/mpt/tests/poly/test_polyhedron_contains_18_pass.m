function test_polyhedron_contains_18_pass
%
% le, lt
%

P = ExamplePoly.randVrep('d',3,'nr',2);

V = P.V;
V(1,:) = V(1,:)*1.00001;
R = Polyhedron('V',V,'R',P.R);

if ~(P<R)
    error('R must be contained in P.');
end

if ~(P<=R)
    error('R must be contained in P.');
end


end