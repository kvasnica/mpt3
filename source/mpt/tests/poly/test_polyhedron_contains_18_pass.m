function test_polyhedron_contains_18_pass
%
% le, lt
%

P = ExamplePoly.randVrep('d',3,'nr',2);

R = Polyhedron('V',P.V,'R',P.R,'lb',[-10;-5;-7],'ub',[8;7;9]);

if ~(P<R)
    error('R must be contained in P.');
end

if ~(P<=R)
    error('R must be contained in P.');
end


end