function test_polyhedron_contains_17_pass
%
% ge, gt
%

P = ExamplePoly.randVrep('d',3,'nr',2);

R = Polyhedron('V',P.V,'R',P.R,'lb',[-10;-5;-7],'ub',[8;7;9]);

if ~(R>P)
    error('R must be contained in P.');
end

if ~(R>=P)
    error('R must be contained in P.');
end


end